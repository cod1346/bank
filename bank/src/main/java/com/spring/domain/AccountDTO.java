package com.spring.domain;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class AccountDTO {
	private String username;
	private String accountNo;
	private int balance;
	private int saving;
	private int deposit;
	private String savingDate;
	private String depositDate;
}


















