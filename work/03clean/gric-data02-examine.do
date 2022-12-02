capture log close
log using "00logs/gric-data02-examine", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-data02-examine.do
 
// Created 
 local dte   2022-01-13
 local who   chanteria milner
 
 
// Modified
 local dte	2022-01-14
 local who	chanteria milner

****************************************************************
//  import data
****************************************************************

 use "_data/gric-data01-label.dta", clear

****************************************************************
//  view data
****************************************************************
 // only 1.84% (13) of respondents say sterilization, dropping those values
 fre bc_rec
 tab vig_race bc_rec
 drop if bc_rec==2
 
 tab vig_race vig_ses
 
 // respondent characteristics
 fre r_race_t
 tab r_race_t r_gender

 // vignette characteristics
 fre vig_group // check for equality (or near equality) across
 tab vig_ses bc_rec
 tab vig_race bc_rec
 tab vig_group bc_rec, row
 
 
 // if you share race/ethnicity of vig, you offer IUD at a higher percentage
 tab vig_group bc_rec if r_race_t==0, row // Black
 tab vig_race bc_rec if r_race_t==1, row // Hispanic
 tab vig_race bc_rec if r_race_t==2, row // White
 tab vig_race bc_rec if r_race_t==4, row // Other
 tab vig_group bc_rec, row
 

****************************************************************
// Weak Open-Ended 
****************************************************************
 
 // weak oe	
 gen weak_oe=0
	// replace weak_oe=1 if prolificid == "[CHANGE]"
 
 la def weak_oe 0 "Not Weak Open-Ended" 1 "Weak Open-Ended"
 la val weak_oe weak_oe
 la var weak_oe "Open-Ended Is Weak"
 
 fre weak_oe
 
	
****************************************************************
// Attention Check
****************************************************************
  
 la def fail 0 "Passed" 1 "Failed" 2 "Forgot"
 
 // name	
 gen fail_namecheck=0
 replace fail_namecheck=1 if vig_name != attn_name
 replace fail_namecheck=2 if attn_name==3 // "forgot" option

 la val fail_namecheck fail
 la var fail_namecheck "Fail Check: Name"
 fre fail_namecheck
 
 	
 // age	
 gen fail_agecheck=0
 replace fail_agecheck=1 if attn_age != 22
 replace fail_agecheck=2 if attn_age==3 // "forgot" option
 
 la val fail_agecheck fail
 la var fail_agecheck "Fail Check: Age"
 fre fail_agecheck

	
 // race
 gen fail_racecheck=0
 replace fail_racecheck=1 if vig_race!=attn_race
 replace fail_racecheck=2 if attn_race==3 // "forgot" option

 la val fail_racecheck fail
 la var fail_racecheck "Fail Check: Race"
 fre fail_racecheck
 
 
 // job
 gen fail_jobcheck=0
 replace fail_jobcheck=1 if vig_job!=attn_job
 replace fail_jobcheck=2 if attn_job==2 // "forgot" option
 	
 la val fail_jobcheck fail
 la var fail_jobcheck "Fail Check: Job"
 fre fail_jobcheck
 
 
 // college
 gen fail_collegecheck=0
 replace fail_collegecheck=1 if vig_college!=attn_college
 replace fail_collegecheck=2 if attn_college==2 // "forgot" option

 la val fail_collegecheck fail
 la var fail_collegecheck "Fail Check: College"
 fre fail_collegecheck
 
 
 // if respondent failed important checks (age, race, and job)
 gen fail=0
 replace fail=1 if fail_agecheck==1 & fail_racecheck==1 & fail_jobcheck==1
 la var fail "Fail Check: Age, Race, and Job"
 label val fail fail
 fre fail

 // list failed prolific ids
 list prolificid if fail==1
 
****************************************************************
// Straightlining	
****************************************************************
* ssc install  respdiff // May need to install

 la def strtline 0 "Not Straightlined" 1 "Straightlined"
 
 // competence scale straighlining
 respdiff strtline_c = nondiff(c_comp-c_skill)
 la var strtline_c "Straightlining: Competence Scale"
 label val strtline_c strtline
 
 fre strtline_c

 
 // warmth scale straighlining
 respdiff strtline_w = nondiff(w_friendly-w_sincere)
 la var strtline_w "Straightlining: Warmth Scale"
 label val strtline_w strtline

 fre strtline_w

 
 // overlap between fail and strtline
 tab fail strtline_c
 tab fail strtline_w
 
 
 // examine prolific id - straightlining competence and warmth
 list prolificid if strtline_c==1 & strtline_w==1
 
 
 // examine prolific id - straightlining & fail
 list prolificid if fail==1 & strtline_c==1
 list prolificid if fail==1 & strtline_w==1
 
****************************************************************
//  missing data check
****************************************************************

 missings report
 missings table 
 missings tag, generate(nmissing)

 fre nmissing

****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-data02-examine.dta", replace

 log close
 exit
