package com.spring.schedule;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.service.AccountService;


@Component
public class Schedule {
//	<ul>
//	<li>second</li>
//	<li>minute</li>
//	<li>hour</li>
//	<li>day of month</li>
//	<li>month</li>
//	<li>day of week</li>
//	</ul>
	
	//@Scheduled(cron = "* 0 * * * *") 매 0분 매초마다(한시간마다) 스케줄링
	//@Scheduled(cron = "* * 0 * * *") 매 00시(자정)매분 매초마다(1일에한번) 스케줄링
	//@Scheduled(cron = "* * * 1 * *") 매월 1일 매초 매분 매시 마다 스케줄링
	/*
	 * @Scheduled(cron = "0 0 2 * * *") public void scheduleTest() {
	 * System.out.println("1번메소드"); }
	 */
	@Autowired
	private AccountService service;
	
	@Scheduled(fixedRate = 60000) //밀리세컨드
	public void schedulerTest2() {
		System.out.println("스케줄링 실행중"); 
		service.updateSaving();
	}
}
