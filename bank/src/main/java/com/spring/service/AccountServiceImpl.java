package com.spring.service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.AccountDTO;
import com.spring.domain.AccountUserDTO;
import com.spring.domain.RecordDTO;
import com.spring.domain.SavingDTO;
import com.spring.mapper.AccountMapper;
import com.spring.util.Encrypt;

@Service
public class AccountServiceImpl implements AccountService {

	@Autowired
	private AccountMapper mapper;

	private Encrypt encrypt;

	@Override
	public int checkUser(String username) {
		return mapper.checkUser(username);
	}


	@Transactional
	@Override
	public boolean registUser(AccountUserDTO dto) {
		try {
			dto.setPassword(encrypt.encrypt(dto.getPassword()));
			mapper.registAccount(dto.getUsername());
			mapper.registUser(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	@Override
	public AccountDTO management(String username) {
		try {
			return mapper.management(username);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public int login(AccountUserDTO dto) {
		try {
			dto.setPassword(encrypt.encrypt(dto.getPassword()));
			return mapper.login(dto);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Transactional
	@Override
	public String checkTransferNo(String accountNo) {
		String username = mapper.checkTransferNo(accountNo);
		System.out.println(username);
		if(username!=null) {
			return mapper.checkName(username);
		}
		return mapper.checkTransferNo(accountNo);
	}

	@Transactional
	@Override
	public boolean action(RecordDTO dto) {
		if(dto.getType().equals("insert")) {
			mapper.recordInsert(dto);
			return mapper.insert(dto)==1?true:false;
		}else if(dto.getType().equals("withdraw")) {
			mapper.recordWiThdraw(dto);
			return mapper.withdraw(dto)==1?true:false;
		}else if(dto.getType().equals("transfer")) {
			mapper.withdraw(dto);
			String fromName = mapper.checkTransferNo(dto.getAccountNo());
			String name = mapper.checkName(fromName);
			int balance = mapper.getBalance(dto.getTransferNo());
			RecordDTO dto1 = new RecordDTO();
			dto1.setAccountNo(dto.getTransferNo());
			dto1.setType("receive");
			dto1.setBalance(balance+dto.getValue());
			dto1.setFromName(name);
			dto1.setValue(dto.getValue());
			dto1.setTransferNo(dto.getAccountNo());
			mapper.insert(dto1);
			//기록
			mapper.recordTransfer(dto);
			mapper.recordReceive(dto1);
			return true;
		}else if(dto.getType().equals("deposit")) {
			System.out.println("예금");
			SavingDTO dto1 = new SavingDTO();
			dto1.setAccountNo(dto.getAccountNo());
			dto1.setType("deposit");
			dto1.setPeriod(dto.getPeriod());
			dto1.setBalance(dto.getValue());
			LocalDateTime currentTime = LocalDateTime.now();
	        LocalDateTime expirationTime = currentTime.plus(dto.getPeriod(), ChronoUnit.SECONDS);
	        dto1.setExpireDate(java.sql.Timestamp.valueOf(expirationTime));
	        mapper.saving(dto);
			mapper.insertSaving(dto1);
			dto.setPrincipal(dto.getValue());
			return mapper.recordInsert(dto)==1?true:false;
		}else{
			System.out.println("적금");
			SavingDTO dto1 = new SavingDTO();
			dto1.setAccountNo(dto.getAccountNo());
			dto1.setType("saving");
			dto1.setPeriod(dto.getPeriod());
			dto1.setBalance(dto.getValue());
			LocalDateTime currentTime = LocalDateTime.now();
	        LocalDateTime expirationTime = currentTime.plus(dto.getPeriod(), ChronoUnit.SECONDS);
	        dto1.setExpireDate(java.sql.Timestamp.valueOf(expirationTime));
	        mapper.saving(dto);
			mapper.insertSaving(dto1);
			dto.setPrincipal(dto.getValue());
			return mapper.recordInsert(dto)==1?true:false;
		}
	}


	@Override
	public List<RecordDTO> recordList(String accountNo) {
		return mapper.recordList(accountNo);
	}

	@Transactional
	@Override
	public void updateSaving() {
		List<SavingDTO> list = mapper.savingList();
		LocalDateTime nowDate = LocalDateTime.now();
		for (SavingDTO dto : list) {
			LocalDateTime expireDate = dto.getExpireDate().toLocalDateTime(); 
			System.out.println("----------"+dto.getType());
	        if (expireDate.isBefore(nowDate)) {
	            System.out.println("적금,예금 만료");
	            int balance=dto.getBalance();
	            int interest=dto.getInterest();
	            int total = balance+interest;
	            AccountDTO accountDTO = mapper.getAccount(dto.getAccountNo());
	            //기록
	            RecordDTO recordDTO = new RecordDTO();
	            recordDTO.setAccountNo(dto.getAccountNo());
	            recordDTO.setType(dto.getType().equals("deposit")?"expireDeposit":"expireSaving");
	            recordDTO.setBalance(accountDTO.getBalance()+total);
	            recordDTO.setValue(total);
	            recordDTO.setPrincipal(dto.getPrincipal());
	            mapper.recordInsert(recordDTO);
	            
	            //(#{accountNo},#{type},#{balance},#{value},sysdate)
	            accountDTO.setBalance(accountDTO.getBalance()+total);
	            mapper.expirationSaving(dto.getSavingNo());
	            mapper.updateBalance(accountDTO);
	        } else {
	        	mapper.updateSaving();
	        	mapper.updateDeposit();
	        }
		}
	}


	@Override
	public List<SavingDTO> savingListAccount(String accountNo) {
		return mapper.savingListAccount(accountNo);
	}


	@Transactional
	@Override
	public boolean getAccountSavingNo(int savingNo) {
		SavingDTO dto = mapper.getAccountSavingNo(savingNo);
		AccountDTO accountDTO = mapper.getAccount(dto.getAccountNo());
		mapper.updateSavingPrincipal(dto);
		RecordDTO recordDTO = new RecordDTO();
		recordDTO.setAccountNo(dto.getAccountNo());
		recordDTO.setType(dto.getType().equals("deposit")?"deleteDeposit":"deleteSaving");
		recordDTO.setBalance(accountDTO.getBalance()+dto.getPrincipal());
		recordDTO.setValue(dto.getPrincipal());
		mapper.recordInsert(recordDTO);
		return mapper.expirationSaving(savingNo)==1?true:false;
	}

	

}
