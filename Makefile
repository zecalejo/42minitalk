# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jnuncio- <jnuncio-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/13 18:12:45 by jnuncio-          #+#    #+#              #
#    Updated: 2023/06/14 20:41:14 by jnuncio-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# HIGHLIGHTING COLOR

HL_GREEN = $(shell tput setab 2)
HL_CYAN = $(shell tput setab 6)

# FONT COLOR

RED = $(shell tput setaf 1)
GREEN = $(shell tput setaf 2)
YELLOW = $(shell tput setaf 3)
RESET = $(shell tput sgr0)

BIN	= bin
INCFT = libft/include
LIBFT = libft/
LIBFT_BIN = libft/libft.a
CC = gcc
CFLAGS = -Wall -Wextra -Werror -I$(INCFT) -Iinclude -g
LFLAGS = -L$(LIBFT) -lft #-fsanitize=address
RM = rm -rf
SRC = $(addprefix src/, server.c client.c)
OBJ = $(SRC:src/%c=bin/%o)
OBJ_SRV = bin/server.o
OBJ_CLT = bin/client.o

all: $(LIBFT) $(BIN) server client

server: $(OBJ_SRV)
	@$(CC) $(OBJ_SRV) $(LFLAGS) -o server

client: $(OBJ_CLT)
	@$(CC) $(OBJ_CLT) $(LFLAGS) -o client

$(BIN):
	@test -d $(BIN) || (mkdir -p $(BIN) &&\
	echo "$(GREEN)Created $(BIN) directory.$(RESET)") ||\
	echo "$(RED)Failed to create $(BIN) directory.$(RESET)"

$(LIBFT): $(LIBFT_BIN)
	@make -C libft --no-print-directory &&\
	echo "" ; echo -n "$(HL_CYAN)libft:$(RESET)" &&\
	echo "$(GREEN) OK!$(RESET)" ||\
	echo "$(RED) KO!$(RESET)"

$(BIN)/%o: src/%c
	@echo -n "$(YELLOW)Creating object file... $(RESET)"
	@$(CC) -c $< $(CFLAGS) -o $@ &&\
	echo "$(GREEN)OK!$(RESET)" || echo "$(RED)KO!$(RESET)"
	
clean: cleanlib hl_minitalk
	@test -n "$(wildcard bin/*.o)" && $(RM) $(OBJ) &&\
	echo "$(GREEN)deleted object files$(RESET)" || true
	@test -d $(BIN) && $(RM) $(BIN) &&\
	echo "$(GREEN)deleted $(BIN) directory$(RESET)" || true
	
fclean: cleanlib fcleanlib clean hl_minitalk
	@test -e server && $(RM) server &&\
	echo "$(GREEN)deleted server$(RESET)" || true
	@test -e client && $(RM) client &&\
	echo "$(GREEN)deleted client$(RESET)" || true

cleanlib: hl_libft
	@test -n "$(wildcard libft/bin/*.o)" &&\
	make clean -C libft --no-print-directory &&\
	echo "$(GREEN)deleted object files$(RESET)" || true

fcleanlib: hl_libft
	@test -e libft/libft.a &&\
	make fclean -C libft --no-print-directory &&\
	echo "$(GREEN)deleted libft.a$(RESET)" || true

hl_minitalk:
	@if [ -n "$(wildcard bin/*.o)" -o -e server -o -e client ]; then \
		echo "$(HL_CYAN)minitalk:$(RESET)"; \
	else \
		echo "$(HL_CYAN)minitalk:$(RESET)$(YELLOW) nothing to clean$(RESET)"; \
	fi

hl_libft:
	@if [ -n "$(wildcard libft/bin/*.o)" -o -e libft/libft.a ]; then \
		echo "$(HL_CYAN)libft:$(RESET)"; \
	else \
		echo "$(HL_CYAN)libft:$(RESET)$(YELLOW) nothing to clean$(RESET)"; \
	fi

re: fclean all

.PHONY: all clean fclean cleanlib fcleanlib re $(LIBFT_BIN)