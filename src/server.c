/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jnuncio- <jnuncio-@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/13 18:40:22 by jnuncio-          #+#    #+#             */
/*   Updated: 2023/06/19 01:14:26 by jnuncio-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

static void	sighandler(int signum, siginfo_t *info, void *context)
{
	static int	bit_cnt = 0;
	static char	current_char = 0;

	(void)context;
	if (signum == SIGUSR1)
		current_char |= (1 << (7 - bit_cnt));
	bit_cnt++;
	if (bit_cnt == 8)
	{
		if (current_char == 0)
		{
			ft_printf("\n");
			usleep(1000);
			kill(info->si_pid, SIGUSR1);
		}
		else
			ft_printf("%c", current_char);
		current_char = 0;
		bit_cnt = 0;
	}
}

int	main(void)
{
	struct sigaction	act;

	act.sa_sigaction = sighandler;
	act.sa_flags = SA_SIGINFO;
	sigaction(SIGUSR1, &act, 0);
	sigaction(SIGUSR2, &act, 0);
	ft_printf("Server PID: %d\n", getpid());
	ft_printf("Waiting for a message...\n\n");
	while (1)
		pause();
	return (0);
}
