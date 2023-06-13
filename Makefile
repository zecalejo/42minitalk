# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jnuncio- <jnuncio-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/13 18:12:45 by jnuncio-          #+#    #+#              #
#    Updated: 2023/06/13 23:14:19 by jnuncio-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

RED = $(shell tput setaf 1)
GREEN = $(shell tput setaf 2)
YELLOW = $(shell tput setaf 3)
RESET = $(shell tput sgr0)

BIN	= bin
INCLFT = libft/include
LIBFT = libft/
LIBFT_BIN = libft/libft.a
CC = gcc
CFLAGS = -Wall -Wextra -Werror -I$(INCLFT) -Iinclude -g
LFLAGS = -L$(LIBFT) -lft #-fsanitize=address
RM = rm -rf
SRC = $(addprefix src/, server.c client.c)
OBJ = $(SRC:src/%c=bin/%o)

all: $(LIBFT) server client 

server: $(BIN) $(OBJ)
	@$(CC) $(OBJ) $(LFLAGS) -o server

client: $(BIN) $(OBJ)
	@$(CC) $(OBJ) $(LFLAGS) -o client

$(BIN):
	@test -d $(BIN) || (mkdir -p $(BIN) &&\
	echo "$(GREEN)Created $(BIN) directory.$(RESET)") ||\
	echo "$(RED)Failed to create $(BIN) directory.$(RESET)"

$(LIBFT): $(LIBFT_BIN)
	@make all -C libft --no-print-directory
	@test -e libft/libft.a && echo "$(GREEN)libft: OK!$(RESET)" ||\
	echo "$(RED)libft: KO!$(RESET)"

$(BIN)/%o: src/%c
	@test -n "$(wildcard bin/*)" ||\
	echo -n "$(YELLOW)Creating object files... $(RESET)"
	@$(CC) -c $< $(CFLAGS) -o $@ &&\
	echo "$(GREEN)OK!$(RESET)"

obj_msg:
	@echo "$(YELLOW)Creating object files$(RESET)"
	
clean:
	@test -n "$(wildcard bin/*.o)" && $(RM) $(OBJ) &&\
	echo "$(GREEN)Deleted object files.$(RESET)" || true
	@test -d $(BIN) && $(RM) $(BIN) &&\
	echo "$(GREEN)Deleted $(BIN) directory.$(RESET)" || true
	
fclean: clean
	@test -e server && $(RM) server &&\
	echo "$(GREEN)Deleted server$(RESET)" || true
	@test -e client && $(RM) client &&\
	echo "$(GREEN)Deleted client$(RESET)" || true

cleanlib:
	@test -n "$(wildcard libft/bin/*.o)" && make clean -C libft --no-print-directory &&\
	echo "$(GREEN)Cleaned libft.$(RESET)"

fcleanlib:
	@test -e libft/libft.a && make fclean -C libft --no-print-directory &&\
	echo "$(GREEN)Full cleaned libft.$(RESET)"
	
ffclean: fclean fcleanlib

re: ffclean all

.PHONY: all clean fclean cleanlib fcleanlib ffclean re $(LIBFT_BIN)