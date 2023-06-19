/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jnuncio- <jnuncio-@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/13 18:40:56 by jnuncio-          #+#    #+#             */
/*   Updated: 2023/06/19 01:08:54 by jnuncio-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

static void	sighandler(int signum)
{
	(void)signum;
	ft_printf("\033[1;32m OK!\033[0m\n");
	exit(0);
}

static void	char2bit(pid_t srv_pid, int mt_wait, int c)
{
	int	shift;

	shift = 8;
	while (shift--)
	{
		if (c & (1 << shift))
			kill(srv_pid, SIGUSR1);
		else
			kill(srv_pid, SIGUSR2);
		usleep(mt_wait);
	}
}

static void	send_msg(int srv_pid, char *msg)
{
	int	mt_wait;

	mt_wait = 100 +((ft_strlen(msg) > 1000) * 500);
	while (*msg)
		char2bit(srv_pid, mt_wait, *msg++);
	char2bit(srv_pid, mt_wait, *msg);
	ft_printf("\033[34mWaiting for Server to respond...\033[0m");
	sleep(mt_wait / 100);
	ft_printf("\n\033[1;31mServer didn't respond in time 🕒!\n");
	ft_printf("Make sure the server is up and running!\033[0m\n");
	exit(0);
}

int	main(int ac, char **av)
{
	pid_t	srv_pid;

	if (ac != 3)
		ft_printf("The program must recieve 2 parameters.\n\033[4mLike this:\033[0m\n\
	\033[0;33m./client [server_PID] \"string to be sent\"\033[0m\n");
	else
	{
		srv_pid = ft_atoi(av[1]);
		if (kill(srv_pid, 0) == -1)
			return (ft_printf("\033[31mInvalid Server PID!\n\033[0m") - 29);
		signal(SIGUSR1, sighandler);
		if (!(*av[2]))
			return (ft_printf("\033[33mNothing to send!\n\033[0m") - 26);
		ft_printf("Sending: \"%s\"\n", av[2]);
		send_msg(srv_pid, av[2]);
		pause();
	}
	return (0);
}
