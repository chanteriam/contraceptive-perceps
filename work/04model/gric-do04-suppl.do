capture log close
log using "00logs/gric-do04-suppl", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-do04-suppl.do
 
// Created 
 local dte   2022-02-03
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-03-13
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-do03-graphs.dta", clear
 
****************************************************************
//  descriptive stats by race of respondent - Black
****************************************************************
*****************
//  competence
***************** 
 // by race
 oneway c_scale vig_race if r_race_t==0, tab
 pwmean c_scale if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest c_scale if r_race_t==0, by(vig_ses)
 
 // by race and ses
 oneway c_scale vig_group if r_race_t==0, tab
 pwmean c_scale if r_race_t==0, over(vig_group) mcompare(tukey) effects

 
*****************
//  warmth
***************** 
 // by race
 oneway w_scale vig_race if r_race_t==0, tab
 pwmean w_scale if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest w_scale if r_race_t==0, by(vig_ses)
 
 // by race and ses
 oneway w_scale vig_group if r_race_t==0, tab
 pwmean w_scale if r_race_t==0, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  quality of life
***************** 
 // now
   // by race
   oneway up_lifequal_now vig_race if r_race_t==0, tab
   pwmean up_lifequal_now if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_now if r_race_t==0, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_now vig_group if r_race_t==0, tab
   pwmean up_lifequal_now if r_race_t==0, over(vig_group) mcompare(tukey) effects

   
 // after up
    // by race
   oneway up_lifequal_up vig_race if r_race_t==0, tab
   pwmean up_lifequal_up if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_up if r_race_t==0, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_up vig_group if r_race_t==0, tab
   pwmean up_lifequal_up if r_race_t==0, over(vig_group) mcompare(tukey) effects


 // for child after up
    // by race
   oneway up_lifequal_child vig_race if r_race_t==0, tab
   pwmean up_lifequal_child if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
   // by ses
   ttest up_lifequal_child if r_race_t==0, by(vig_ses)
 
   // by race and ses
   oneway up_lifequal_child vig_group if r_race_t==0, tab
   pwmean up_lifequal_child if r_race_t==0, over(vig_group) mcompare(tukey) effects
   
   
*****************
//  promisc
***************** 
 // by race
 oneway promisc vig_race if r_race_t==0, tab
 pwmean promisc if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest promisc if r_race_t==0, by(vig_ses)
 
 // by race and ses
 oneway promisc vig_group if r_race_t==0, tab
 pwmean promisc if r_race_t==0, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  up_likely
***************** 
 // by race
 oneway up_likely vig_race if r_race_t==0, tab
 pwmean up_likely if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest up_likely if r_race_t==0, by(vig_ses)
 
 // by race and ses
 oneway up_likely vig_group if r_race_t==0, tab
 pwmean up_likely if r_race_t==0, over(vig_group) mcompare(tukey) effects
 
 
*****************
//  up_welf
***************** 
 // by race
 oneway up_welf vig_race if r_race_t==0, tab
 pwmean up_welf if r_race_t==0, over(vig_race) mcompare(tukey) effects
 
 // by ses
 ttest up_welf if r_race_t==0, by(vig_ses)
 
 // by race and ses
 oneway up_welf vig_group if r_race_t==0, tab
 pwmean up_welf if r_race_t==0, over(vig_group) mcompare(tukey) effects
 
****************************************************************
//  models by race of respondent - Black
****************************************************************

***************** 
//  ses
***************** 
  // key indp var - ses
 logistic bc_rec i.vig_ses if r_race_t==0
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==0
	
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_ses c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==0
 
 // controls: all together
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==0

*****************
//  race
***************** 
 // key independent variables - race
 logistic bc_rec i.vig_race if r_race_t==0
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==0
		    
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_race c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==0

 // controls: all together
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==0

  
*****************
//  race + ses
***************** 
 // key indp var - race + ses
 logistic bc_rec i.vig_group if r_race_t==0
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==0
 
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_group c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==0
 
 // controls: all together
  logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==0

				 
****************************************************************
//  models by race of respondent - Hispanic/Latino
****************************************************************

***************** 
//  ses
***************** 
  // key indp var - ses
 logistic bc_rec i.vig_ses if r_race_t==1
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==1
	
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_ses c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==1
 
 // controls: all together
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==1

*****************
//  race
***************** 
 // key independent variables - race
 logistic bc_rec i.vig_race if r_race_t==1

 // controls: characteristics of respondents
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==1
		   
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_race c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==1

 // controls: all together
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==1

  
*****************
//  race + ses
***************** 
 // key indp var - race + ses
 logistic bc_rec i.vig_group if r_race_t==1
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==1
 
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_group c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==1

 // controls: all together
  logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==1	

				 
****************************************************************
//  models by race of respondent - White
****************************************************************

***************** 
//  ses
***************** 
  // key indp var - ses
 logistic bc_rec i.vig_ses if r_race_t==2
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==2
	
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_ses c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==2
 
 // controls: all together
 logistic bc_rec i.vig_ses r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==2

*****************
//  race
***************** 
 // key independent variables - race
 logistic bc_rec i.vig_race if r_race_t==2

 // controls: characteristics of respondents
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==2
		   
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_race c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==2

 // controls: all together
 logistic bc_rec i.vig_race r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==2

  
*****************
//  race + ses
***************** 
 // key indp var - race + ses
 logistic bc_rec i.vig_group if r_race_t==2
 
 // controls: characteristics of respondents
 logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill if r_race_t==2
 
 // controls: respondent perception of vig character
 logistic bc_rec i.vig_group c_scale w_scale up_lifequal_now promisc ///
		  up_likely up_welf up_resp_s if r_race_t==2

 // controls: all together
  logistic bc_rec i.vig_group r_age r_stab_child i.r_gender i.r_educ /// 
				 com_iud com_pill c_scale w_scale up_lifequal_now promisc ///
				 up_likely up_welf up_resp_s if r_race_t==2					 
				 

****************************************************************
//  NCSA graphs
****************************************************************

*****************
//  descriptives
***************** 

 // competence
 graph bar (mean) c_scale, over(vig_ses, sort(1)) bargap(50) ///
 title("Figure #. Perceived Competence by Vignette Socioeconomic Status") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Competence") ///
 ylabel(0(2)10) bar(1, color(navy)) bar(2, color(black)) legend(order(2 1))
 graph export "/Users/shaymilner/Documents/Spring 2022/SOC4981/04 Presentations & Conferences/graphs.png", replace
 
 
 graph bar (mean) c_scale, over(vig_ses) bargap(50)
 // warmth
 
 // likelihood of UP
 
 // likelihood of using welfare
 
 // state responsibility
 
 ttest up_resp_s, by(vig_ses)

****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-do04-suppl.dta", replace

 log close
 exit
