package com.spring.mapper;

import java.util.List;

import com.spring.domain.AccountDTO;
import com.spring.domain.AccountUserDTO;
import com.spring.domain.RecordDTO;
import com.spring.domain.SavingDTO;

public interface AccountMapper {
	public int checkUser(String username);
	public int registUser(AccountUserDTO dto);
	public int registAccount(String username);
	public AccountDTO management(String username);
	public int login(AccountUserDTO dto);
	public String checkTransferNo(String accountNo);
	public String checkName(String username);
	public int insert(RecordDTO dto);
	public int withdraw(RecordDTO dto);
	public int recordInsert(RecordDTO dto);
	public int recordTransfer(RecordDTO dto);
	public int recordReceive(RecordDTO dto);
	public int recordWiThdraw(RecordDTO dto);
	public int getBalance(String accountNo);
	public List<RecordDTO> recordList(String accountNo);
	public int insertSaving(SavingDTO dto);
	public List<SavingDTO> savingList();
	public int updateDeposit();
	public int updateSaving();
	public AccountDTO getAccount(String accountNo);
	public int updateBalance(AccountDTO dto);
	public int expirationSaving(int savingNo);
	public List<SavingDTO> savingListAccount(String accountNo);
	public int saving(RecordDTO dto);
	public SavingDTO getAccountSavingNo(int savingNo);
	public int updateSavingPrincipal(SavingDTO dto);
}
