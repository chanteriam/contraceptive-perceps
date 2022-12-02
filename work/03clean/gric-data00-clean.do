capture log close
log using "00logs/gric-data00-clean", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-data00-clean.do
 
// Created 
 local dte   2022-01-13
 local who   chanteria milner

 
// Modified
 local dte	2022-01-14
 local who	chanteria milner
 
 
 di "`tag'"

 
****************************************************************
//  import data
****************************************************************
 
 import excel "_rawdata/gric-2022-02-23-02.xlsx", firstrow case(lower)

****************************************************************
//  drop variables/responses
****************************************************************
 
 // unnecessary data
 drop startdate-responseid
 drop distributionchannel-userlanguage
 drop prolific_pid-vignette
 drop timing*
 drop q99_firstclick-q99_clickcount
 drop r_bc_6_textparenttopics-r_bc_6_texttopics
 
 // informed consent & u.s./age verification
 drop if is_agree==2 // look at settings for partial responses
 drop if rescheck==2
 drop if agecheck==2


****************************************************************
//  rename variables
****************************************************************

 // verification
 la var prolificid "Prolific ID"
 la var rescheck "US Residece Verification"
 la var agecheck "Age Verification"

 
 // attention checks
 la var attn_name "Attention Check - Name"
 la var attn_race "Attention Check - Race"
 la var attn_job "Attention Check - Job"
 la var attn_college "Attention Check - College Attendance"

 
 // demographics
 la var r_gender "Respondent Gender"
 la var r_age "Respondent Age"
 la var r_hispanic "Is R Hispanic/Latino?"
 la var r_pol "Respondent Political Affiliation"
 la var r_educ "Respondent Education"
 la var r_relig "Respondent Religion"
 la var r_stab_child "R's Financial Stability: Childhood (1-10)"
 la var r_stab_now "R's Financial Stability: Now (1-10)"
 la var r_sex_enc "R has had a Voluntary Sexual Encounter"

 rename r_gender_4_text r_genderopen
	la var r_genderopen "Repondent Gender - open"

 rename r_relig_6_text r_religopen
	la var r_religopen "Respondent Religion - open"

 rename r_bc_7_text r_bcopen
	la var r_bcopen "Respondent Birth Control - open"

	
 // char's life quality
 rename lifequal_now up_lifequal_now
 rename lifequal_up up_lifequal_up
 rename lifequal_child up_lifequal_child
 
****************************************************************
//  drop incomplete responses
****************************************************************
 
 drop if bc_rec==. // dependent measure
 drop if attn_age==.
 
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-data00-clean.dta", replace

 log close
 exit
