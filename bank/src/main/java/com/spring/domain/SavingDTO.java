package com.spring.domain;


import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter @Setter
public class SavingDTO {
	private String accountNo;
	private String type;
	private String savingDate;
	private String updateDate;
	private int balance;
	private int interest;
	private int period;
	private Timestamp expireDate;
	private int savingNo;
	private int principal;
}


















