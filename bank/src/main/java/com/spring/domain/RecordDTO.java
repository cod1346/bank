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
public class RecordDTO {
	private String accountNo;
	private String type;
	private int balance;
	private String doDate;
	private String transferNo;
	private String toName;
	private String fromName;
	private int value;
	private int charge;
	private int period;
	private int principal;
}


















