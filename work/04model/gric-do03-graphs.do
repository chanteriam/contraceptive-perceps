capture log close
log using "00logs/gric-do03-graphs", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-do03-graphs.do
 
// Created 
 local dte   2022-02-03
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-02-25
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-do02-02-analysis_tables.dta", clear
 
****************************************************************
//  descriptive graphs
****************************************************************

****************
// bc rec
****************
 // by SES
 graph bar (mean) bc_rec, over(vig_ses, sort(1)) asyvars bargap(50) ///
 title("Figure #. Contraceptive Recommendation by Vignette Socioeconomic Status") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 note("0 = IUD, 1 = BCP", size(small) position(6)) ///
 ytitle("Mean Contraceptive Recommendation") ///
 ylabel(0(.2)1) bar(1, color(navy)) bar(2, color(black)) legend(order(2 1))
 graph export "02graphs/gric-do03-01-bcrec_s.png", replace
 
 
 // by race
 graph bar (mean) bc_rec, over(vig_race) asyvars bargap(50) ///
 title("Figure #. Contraceptive Recommendation by Vignette Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 note("0 = IUD, 1 = BCP", size(small) position(6)) ///
 ytitle("Mean Contraceptive Recommendation") ///
 ylabel(0(.2)1) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 graph export "02graphs/gric-do03-02-bcrec_r.png", replace
 
 // by SES + race
 graph bar (mean) bc_rec, over(vig_race) asyvars bargap(25) ///
 over(vig_ses, sort(1)) ///
 title("Figure #. Contraceptive Recommendation by Vignette SES and Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 note("0 = IUD, 1 = BCP", size(small) position(6)) ///
 ytitle("Mean Contraceptive Recommendation") ///
 ylabel(0(.2)1) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 graph export "02graphs/gric-do03-03-bcrec_rs.png", replace
 
 
****************
// competence
****************
 // by SES
 graph bar (mean) c_scale, over(vig_ses, sort(1)) asyvars bargap(50) ///
 title("Figure #. Perceived Competence by Vignette Socioeconomic Status") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Competence") ///
 ylabel(0(2)10) bar(1, color(navy)) bar(2, color(black)) legend(order(2 1))
 graph export "02graphs/gric-do03-04-comp_s.png", replace
 
 // by race
 graph bar (mean) c_scale, over(vig_race) asyvars bargap(50) ///
 title("Figure #. Perceived Competence by Vignette Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Competence") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 graph export "02graphs/gric-do03-05-comp_r.png", replace

 // by SES + race
 graph bar (mean) c_scale, over(vig_race) asyvars bargap(25) ///
 over(vig_ses, sort(1)) ///
 title("Figure #. Perceived Competence by Vignette SES and Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Competence") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 graph export "02graphs/gric-do03-06-comp_rs.png", replace

 
****************
// warmth
****************
 // by SES
 graph bar (mean) w_scale, over(vig_ses, sort(1)) asyvars bargap(50) ///
 title("Figure #. Perceived Warmth by Vignette Socioeconomic Status") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Warmth") ///
 ylabel(0(2)10) bar(1, color(navy)) bar(2, color(black)) legend(order(2 1))
 graph export "02graphs/gric-do03-07-warm_s.png", replace

 
 // by race
 graph bar (mean) w_scale, over(vig_race, sort(1)) asyvars bargap(50) ///
 title("Figure #. Perceived Warmth by Vignette Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Warmth") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy)) ////
 legend(order(1 2 3))
 graph export "02graphs/gric-do03-08-warm_r.png", replace
 
 // by SES + race
 graph bar (mean) w_scale, over(vig_race) asyvars bargap(25) ///
 over(vig_ses, sort(1)) ///
 title("Figure #. Perceived Warmth by Vignette SES and Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Scaled Perceived Warmth") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 graph export "02graphs/gric-do03-09-warm_rs.png", replace
 
****************
// promisc
****************
 // by SES
 graph bar (mean) promisc, over(vig_ses, sort(1) descending) asyvars bargap(50) ///
 title("Figure #. Perceived Sexual Promiscuity by Vignette Socioeconomic Status") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Perceived Promiscuity") ///
 ylabel(0(2)10) bar(1, color(navy)) bar(2, color(black)) legend(order(2 1))
 
 // by race
 graph bar (mean) promisc, over(vig_race) asyvars bargap(50) ///
 title("Figure #. Perceived Sexual Promiscuity by Vignette Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Perceived Promiscuity") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy)) 
 
 // by SES + race
 graph bar (mean) promisc, over(vig_race) asyvars bargap(25) ///
 over(vig_ses, sort(1) descending) ///
 title("Figure #. Perceived Sexual Promiscuity by Vignette SES and Race") ///
 subtitle("Public Contraceptive Recommendation Experiment 2022, n=695") ///
 ytitle("Mean Perceived Promiscuity") ///
 ylabel(0(2)10) bar(1, color(gray)) bar(2, color(black)) bar(3, color(navy))
 
****************************************************************
//  analysis graphs
****************************************************************
 
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-do03-graphs.dta", replace

 log close
 exit
