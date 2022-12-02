capture log close
log using "00logs/gric-data01-label", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-data01-label.do
 
// Created 
 local dte   2022-01-13
 local who   chanteria milner
 
 
// Modified
 local dte	2022-01-14
 local who	chanteria milner


****************************************************************
//  import data
****************************************************************

 use "_data/gric-data00-clean.dta", clear

 order prolificid vig_race vig_job, before(is_agree)

****************************************************************
//  label variables
****************************************************************

**********
/// Front matter	
**********	
 
 // vig name
 encode vig_name, gen(vig_name2)
 drop vig_name
 rename vig_name2 vig_name
 la var vig_name "Vignette Name"
 replace vig_name=0 if vig_name==1
 replace vig_name=1 if vig_name==2
 replace vig_name=2 if vig_name==3
 label define vig_name 0 "Alexis" 1 "Emily" 2 "Sara"
 label val vig_name vig_name

 
 // vig race
 encode vig_race, gen(vig_race2)
 drop vig_race
 rename vig_race2 vig_race
 la var vig_race "Vignette Race/Ethnicity"
 replace vig_race=0 if vig_race==1
 replace vig_race=1 if vig_race==2
 replace vig_race=2 if vig_race==3
 label define vig_race 0 "Black" 1 "Latina" 2 "White"
 label val vig_race vig_race

 
 // vig college
 encode vig_college, gen(vig_college2)
 drop vig_college 
 rename vig_college2 vig_college
 la var vig_college "Vignette College"
 replace vig_college=0 if vig_college==1
 replace vig_college=1 if vig_college==2
 label define vig_college 0 "No" 1 "Yes"
 label val vig_college vig_college
 

 // vig job
 encode vig_job, gen(vig_job2)
 drop vig_job
 rename vig_job2 vig_job
 la var vig_job "Vignette Job"
 replace vig_job=0 if vig_job==1
 replace vig_job=1 if vig_job==2
 label define vig_job 0 "Bank" 1 "House Cleaner"
 label val vig_job vig_job

 
 // vig ses
 gen vig_ses = vig_job
 la var vig_ses "Vignette Socio-economic Status"
 label define vig_ses 0 "high-SES" 1 "low-SES"
 label val vig_ses vig_ses
 
 
 // vig group (based on race and SES)
 gen vig_group=0 // black, low-income as base
 replace vig_group=1 if vig_race==1 & vig_ses==1 // latina, low-ses
 replace vig_group=2 if vig_race==2 & vig_ses==1 // white, low-ses
 replace vig_group=3 if vig_race==0 & vig_ses==0 // black, high-ses
 replace vig_group=4 if vig_race==1 & vig_ses==0 // latina, high-ses
 replace vig_group=5 if vig_race==2 & vig_ses==0 // white, high-ses
 label define vig_group 0 "Black, Low-SES" ///
						1 "Latina, Low-SES" ///
						2 "White, Low-SES"	///
						3 "Black, High-SES"	///
						4 "Latina, High-SES"	///
						5 "White, High-SES"
 label val vig_group vig_group
 la var vig_group "Vignette Group (by race/ethnicity and SES)"
 
 
 order prolificid vig_race vig_job vig_ses, before(is_agree)

	
**********
/// Scales	
**********

 // competent (SCM)
 la var c_comp		"Competent: Competent (1-10)"
 la var c_conf		"Competent: Confident (1-10)"
 la var c_capable	"Competent: Confident (1-10)"
 la var c_efficient	"Competent: Efficient (1-10)"
 la var c_intel		"Competent: Intelligent (1-10)"
 la var c_skill		"Compentent: Skillfull (1-10)"
 
 // warm (SCM)
 la var w_friendly	"Warm: Friendly (1-10)"
 la var w_wellint	"Warm: Well-intentioned (1-10)"
 la var w_trust		"Warm: Trust-worthy (1-10)"
 la var w_warm		"Warm: Warm (1-10)"
 la var w_goodnat	"Warm: Good-natured (1-10)"
 la var w_sincere	"Warm: Sincere (1-10)"
 
 // sexuality & unintended pregnancy
 la var promisc 			 "How sexually promiscuous is character?"
 la var up_prob 			 "How problematic is UP to most people?"
 la var up_lifequal_now 	 "What is character's quality of life now?"
 la var up_lifequal_up 	 	 "What would be character's life quality after UP?"
 la var up_lifequal_child 	 "What would be character's child's life quality after UP?"
 la var up_likely 		 	 "What is character's likelihood of having an UP?"
 la var up_wel 			 	 "What is character's likelihood of using welfare after UP?"
 la var up_resp_s 		 	 "How responsible is state for character's UP?"
 la var up_resp_c 		 	 "How responsible is character for character's UP?"
	

**********
/// Dependent measure	
**********
 
 // recommendation 
 la var bc_rec "What contraception should character use?"
 replace bc_rec=0 if bc_rec==1
 replace bc_rec=1 if bc_rec==2
 replace bc_rec=2 if bc_rec==3
 label define bc_rec 0 "IUD" 1 "Pill" 2 "Sterilization"
 label val bc_rec bc_rec

 rename bc_rec_text bc_recopen
	la var bc_recopen "Please explain why you chose this contraceptive."
 
 
 // how common is x contraceptive?
 la var com_iud 		"Perceived Contraceptive Prevalence: IUD (1-10)"
 la var com_implant		"Perceived Contraceptive Prevalence: Implant (1-10)"
 la var com_sterile		"Perceived Contraceptive Prevalence: Sterilization (1-10)"
 la var com_pill		"Perceived Contraceptive Prevalence: Pill (1-10)"
 la var com_condom		"Perceived Contraceptive Prevalence: Male Condom (1-10)"
 la var com_withdraw	"Perceived Contraceptive Prevalence: Withdrawal (1-10)"
	


**********
///  Attention checks	
**********
 
 // name
 replace attn_name=0 if attn_name==1
 replace attn_name=1 if attn_name==2
 replace attn_name=2 if attn_name==3
 replace attn_name=3 if attn_name==4
 label define attn_name 0 "Alexis" 1 "Emily" 2 "Sara" 3 "Forgot"
 label val attn_name attn_name
 
 
 // race
 replace attn_race=0 if attn_race==1
 replace attn_race=1 if attn_race==2
 replace attn_race=2 if attn_race==3
 replace attn_race=3 if attn_race==4
 label define attn_race 0 "Black" 1 "Hispanic" 2 "White" 3 "Forgot"
 label val attn_race attn_race
 
 
 // age
 label define attn_age 3 "Forgot"
 label val attn_age attn_age
 
 
 // job
 replace attn_job=0 if attn_job==1
 replace attn_job=1 if attn_job==2
 replace attn_job=2 if attn_job==3
 label define attn_job 0 "Bank" 1 "House Cleaner" 2 "Forgot"
 label val attn_job attn_job
 
 
 // college
 replace attn_college=0 if attn_college==2
 replace attn_college=2 if attn_college==3
 label define attn_college 0 "No" 1 "Yes" 2 "Forgot"
 label val attn_college attn_college



**********
///  Demographics	
**********

 // age - categorical
 gen r_age_c=.
	 replace r_age_c=0 if r_age < 25
	 replace r_age_c=1 if r_age > 24 & r_age < 35 
	 replace r_age_c=2 if r_age > 34 & r_age < 45
	 replace r_age_c=3 if r_age > 44 & r_age < 55
	 replace r_age_c=4 if r_age > 54 & r_age < 65
	 replace r_age_c=5 if r_age > 64
 label define r_age_c 0 "18-24" 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65+"
 label val r_age_c r_age_c
 la var r_age_c "Respondent Age - Categorical"
 
 // gender
 replace r_gender=0 if r_gender==1
 replace r_gender=1 if r_gender==2
 replace r_gender=2 if r_gender==3 | r_gender==4
 label define r_gender 0 "Woman" 1 "Man" 2 "Nonbinary or Other Gender"
 label val r_gender r_gender
 

 // race/ethnicity
 split r_race, parse(,)
 drop r_race
	
 gen r_race = .
	 // edit based on multi races
	 // collapse Amerindian, asian, and hawaiin into other
	 destring r_race1 r_race2 r_race3, replace // edit based on multi races
	 replace r_race=0 if r_race1==1 & r_race2==. & r_race3==.
	 replace r_race=1 if r_race1==2 & r_race2==. & r_race3==.
	 replace r_race=2 if r_race1==3 & r_race2==. & r_race3==.
	 replace r_race=3 if r_race1==4 & r_race2==. & r_race3==.
	 replace r_race=4 if r_race1==5 & r_race2==. & r_race3==.
	 replace r_race=5 if r_race1==6 & r_race2==. & r_race3==.
	 replace r_race=6 if r_race1!=. & r_race2!=. 
 
 la var r_race "Respondent Race/Ethnicity"
 label define r_race 0 "American Indian/Alaskan Native" 1 "Asian" 2 "Black" ///
 					3 "Native Hawaiian or Pacific Islander" 4 "White" ///
 					5 "Other"  6 "Multiracial"
 label val r_race r_race
 drop r_race1 r_race2 r_race3 // edit based on multi races
 
 replace r_hispanic=0 if r_hispanic==2
 label define r_hispanic 0 "Not Hispanic" 1 "Hispanic" 
 label val r_hispanic r_hispanic
 

 // race/ethnicity truncated - for analytical purposes
 gen r_race_t =.
 	replace r_race_t=0 if r_race==2 &r_hispanic==0 // black, non-hispanic
	replace r_race_t=1 if r_hispanic==1 // hispanic
	replace r_race_t=2 if r_race==4 & r_hispanic==0 // white, non-hispanic
	replace r_race_t=3 if (r_race==0 | r_race==1 | r_race==3 | r_race==5 | ///
						   r_race==6) & r_hispanic==0 // other
	 
	label var r_race_t "Respondent Race/Ethnicity"
	label define r_race_t 0 "Non-Hispanic Black" 1 "Hispanic" 2 "Non-Hispanic White" ///
						  3 "Non-Hispanic Other"
	label val r_race_t r_race_t
	 	
		
 // political affiliation
 replace r_pol=0 if r_pol==1
 replace r_pol=1 if r_pol==2
 replace r_pol=2 if r_pol==3
 replace r_pol=3 if r_pol==4
 replace r_pol=4 if r_pol==5
 label define r_pol 0 "Very Liberal" 1 "Liberal" 2 "Moderate" 3 "Conservative" ///
 					4 "Very Conservative"
 label val r_pol r_pol
 
 
 // political affiliation - truncated
 gen r_pol_t=.
	replace r_pol_t=0 if r_pol==0 | r_pol==1
	replace r_pol_t=1 if r_pol==2
	replace r_pol_t=2 if r_pol==3 | r_pol==4

 label define r_pol_t 0 "Liberal" 1 "Moderate" 2 "Conservative"
 label val r_pol_t r_pol_t
 label var r_pol_t "Respondent Political Affiliation - Truncated"
  
 
 // education
 replace r_educ=0 if r_educ==1 | r_educ==2 // hs or less
 replace r_educ=1 if r_educ==3
 replace r_educ=2 if r_educ==4
 replace r_educ=3 if r_educ==5
 replace r_educ=4 if r_educ==6 // master's or more
 label define r_educ 0 "High School Diploma/GED or Less" ///
					 1 "Some College" 2 "2-Year Degree" 3 "4-Year Degree" ///
					 4 "Master's, Doctorate, or Professional Degree"
 label val r_educ r_educ
 
  
 // religion - categorical
 replace r_relig=0 if r_relig==1 // Catholic
 replace r_relig=1 if r_relig==2 // Jewish
 replace r_relig=2 if r_relig==3 // Muslum
 replace r_relig=3 if r_relig==4 // Protestant
 replace r_relig=4 if r_relig==5 // None
 replace r_relig=5 if r_relig==6 // Other
 label define r_relig 0 "Catholic" 1 "Jewish" 2 "Muslim" 3 "Protestant" ///
					  4 "None" 5 "Other"
 label val r_relig r_relig
 
 
 // religion - binary
 gen r_relig_b=.
	replace r_relig_b=0 if r_relig==4
	replace r_relig_b=1 if r_relig!=4
 label var r_relig_b "Respondent is Religious"
 label define r_relig_b 0 "Non-Religious" 1 "Religious"
 label val r_relig_b r_relig_b

 
 // opposite gendered sexual encounter
 replace r_sex_enc=0 if r_sex_enc==2
 replace r_sex_enc=2 if r_sex_enc==. 
 label define r_sex_enc 0 "No" 1 "Yes" 2 "Unanswered"
 label val r_sex_enc r_sex_enc

 
 // contraception usage
 split r_bc, parse(,)

	 // add more as there are multiple bc usages
	destring r_bc1 r_bc2 r_bc3 r_bc4 r_bc5 /*r_bc6 r_bc7 r_bc8 */ , replace
	
	// none (0)
	gen r_nobc = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_nobc=1 if `v'==0
		}
		la var r_nobc "Respondent Contraception: None"
	
	// bcp (1)
	gen r_pill = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_pill=1 if `v'==1
		}
		la var r_pill "Respondent Contraception: The Pill"
	
	// iud (2)
	gen r_iud = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_iud=1 if `v'==2
		}
		la var r_iud "Respondent Contraception: IUD"
		
	// male condom (3)
	gen r_condom = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_condom=1 if `v'==3
		}
		la var r_condom "Respondent Contraception: Male Condom"
	
	// implant (4)
	gen r_implant = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_implant=1 if `v'==4
		}
		la var r_implant "Respondent Contraception: Subdermal Implant"
	
	// female sterilization (5)
	gen r_sterile = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_sterile=1 if `v'==5
		}
		la var r_sterile "Respondent Contraception: Female Sterilization"
	
	// withdrawal (6)
	gen r_withdraw = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_withdraw=1 if `v'==6
		}
		la var r_withdraw "Respondent Contraception: Withdrawal"
	
	// other bc (7)
	gen r_other = 0
		foreach v of varlist r_bc1-r_bc5 { // change as num BC increases, up to r_bc8
			replace r_other=1 if `v'==7
		}
		la var r_other "Respondent Contraception: Other"
		
	// label variables
	la def bc_usage 0 "Have Not Used" 1 "Have Used"
	foreach v of varlist r_nobc-r_other {
		label val `v' bc_usage
	}
	
 drop r_bc // however, don't want to drop open-end
 drop r_bc1-r_bc5 // change as num BC increases, up to r_bc8
 order r_bcopen, after(r_other)
	
	
 // in-group variables (based on race, gender, and/or bc usage)
  // race
  gen ingroup_race = 0
	replace ingroup_race = 1 if r_race_t==vig_race
	la var ingroup_race "Ingroup: Race"
	
	
  // gender
  gen ingroup_gender = 0
	replace ingroup_gender = 1 if r_gender == 0 // woman
	la var ingroup_gender "Ingroup: Gender"
 
 // bc usage
 gen ingroup_bc = 0
	replace ingroup_bc = 1 if bc_rec == 0 & r_iud==1 // IUD
	replace ingroup_bc = 1 if bc_rec == 1 & r_pill==1 // BCP
	replace ingroup_bc = 1 if bc_rec == 2 & r_sterile==1 // Sterilization
	la var ingroup_bc "Ingroup: Contraceptive Usage"

 // race & gender
 gen ingroup_rg=0
	replace ingroup_rg=1 if ingroup_race==1 & ingroup_gender==1
	la var ingroup_rg "Ingroup: Race and Gender"

 // bc & gender
 gen ingroup_bcg=0
	replace ingroup_bcg=1 if ingroup_bc==1 & ingroup_gender==1
	la var ingroup_bcg "Ingroup: Contraceptive Usage and Gender"

 // bc & race
 gen ingroup_bcr=0
	replace ingroup_bcr=1 if ingroup_bc==1 & ingroup_race==1
	la var ingroup_bcr "Ingroup: Contraceptive Usage and Race"

 // bc, race, & gender
 gen ingroup=0
	replace ingroup=1 if ingroup_bc==1 & ingroup_race==1 & ingroup_gender==1
	la var ingroup_bcr "Ingroup: Contraceptive Usage, Race, & Gender"
		
	
 la def ingroup 0 "Outgroup" 1 "Ingroup"
 la val ingrou* ingroup
  
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-data01-label.dta", replace

 log close
 exit
 
