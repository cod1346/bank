package com.spring.service;

import java.util.List;

import com.spring.domain.AccountDTO;
import com.spring.domain.AccountUserDTO;
import com.spring.domain.RecordDTO;
import com.spring.domain.SavingDTO;


public interface AccountService {
	public int checkUser(String username);
	public boolean registUser(AccountUserDTO dto);
	public AccountDTO management(String username);
	public int login(AccountUserDTO dto);
	public String checkTransferNo(String accountNo);
	public boolean action(RecordDTO dto);
	public List<RecordDTO> recordList(String accountNo);
	//public List<SavingDTO> savingList();
	//public boolean updateDeposit();
	public void updateSaving();
	public List<SavingDTO> savingListAccount(String accountNo);
	public boolean getAccountSavingNo(int savingNo);
}
