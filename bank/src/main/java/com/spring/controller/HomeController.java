package com.spring.controller;

import java.util.List;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.spring.domain.AccountDTO;
import com.spring.domain.AccountUserDTO;
import com.spring.domain.EmailDTO;
import com.spring.domain.RecordDTO;
import com.spring.domain.SavingDTO;
import com.spring.service.AccountService;

import lombok.extern.slf4j.Slf4j;

@Controller @Slf4j
public class HomeController {
	
		@Autowired
		private AccountService service;
		@Autowired
		private JavaMailSender mailSender;
		
		@GetMapping("/")
		public String home() {
			log.info("home요청");
			return "home";
		}
		@GetMapping("/register")
		public void registerGet() {
			log.info("계좌등록페이지 요청");
		}
		@PostMapping("/register")
		public String registerPost(AccountUserDTO dto) {
			log.info("계좌등록 요청");
			service.registUser(dto);
			return "redirect:/"; 
		}
		
		@PostMapping("/checkEmail")
	    public ResponseEntity<String> checkEmail(@RequestBody EmailDTO dto) {
			try {
				MimeMessage mimeMessage = mailSender.createMimeMessage();
			    MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
	 
			    messageHelper.setFrom("choshopping@gmail.com"); // 보내는사람사람 이메일 
			    messageHelper.setTo(dto.getTo()); // 받는사람 이메일
			    messageHelper.setSubject("Cho Bank"); // 메일제목
			    messageHelper.setText("Cho Bank 인증번호 : "+dto.getCode(),true); // 메일 내용
	 
			    mailSender.send(mimeMessage);
			    return new ResponseEntity<>(HttpStatus.OK);
			} catch (Exception e) {
				e.printStackTrace();
				return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
			}
	    }
		@PostMapping("/checkUsername")
		public ResponseEntity<Integer> checkUsername(String username){
			System.out.println(username);
			int check = service.checkUser(username);
			return new ResponseEntity<>(check,HttpStatus.OK);
		}
		@PostMapping("/login")
		public ResponseEntity<Integer> login(@RequestBody AccountUserDTO dto) {
			int login = service.login(dto);
			return new ResponseEntity<>(login,HttpStatus.OK);
		}
		
		@PostMapping("/management")
		public void management(String username,Model model) {
			AccountDTO dto=service.management(username);
			model.addAttribute("dto", dto);
		}
		@GetMapping(value="/checkTransferNo", produces="text/plain; charset=UTF-8")
		public ResponseEntity<String> checkTransferNo(String accountNo){
			String name = service.checkTransferNo(accountNo);
			System.out.println(name);
			if(name==null) {
				return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
			}
			return new ResponseEntity<String>(name,HttpStatus.OK);
		}
		@PostMapping("/record")
		public ResponseEntity<String> record(@RequestBody RecordDTO dto){
			System.out.println(dto);
			dto.setAccountNo(dto.getAccountNo().trim());
			service.action(dto);
			return new ResponseEntity<String>(HttpStatus.OK);
		}
		@PostMapping("/recordPost")
		public ResponseEntity<List<RecordDTO>> recordPost(String accountNo){
			List<RecordDTO> list = service.recordList(accountNo);
			return new ResponseEntity<List<RecordDTO>>(list,HttpStatus.OK);
		}
		@PostMapping("/savingList")
		public ResponseEntity<List<SavingDTO>> savingList(String accountNo){
			List<SavingDTO> list = service.savingListAccount(accountNo);
			return new ResponseEntity<List<SavingDTO>>(list,HttpStatus.OK);
		}
		@PostMapping("/deleteSaving")
		public ResponseEntity<String> deleteSaving(int savingNo){
			System.out.println("예적금 해지신청");
			service.getAccountSavingNo(savingNo);
			
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
}
