capture log close
log using "00logs/gric-data03-scales", replace text
 
//  setup
 
 version 16.1
 set linesize 80
 clear all
 macro drop _all
 set matsize 100, perm

 
 local pgm   gric-data03-scales.do
 
// Created 
 local dte   2022-01-14
 local who   chanteria milner
 local tag   "`pgm'.do `who' `dte'"
 

// Modified
 local dte 	2022-01-15
 local who 	chanteria milner
 
 di "`tag'"


****************************************************************
//  import data
****************************************************************

 use "_data/gric-data02-examine.dta", clear
  
****************************************************************
// Generate Scales
****************************************************************

***********
//competence alpha=0.9557
***********
 
 pwcorr c_comp c_conf c_capable c_efficient c_intel c_skill // is there a correlation between all of these? >=0.7 is ideal
 
 alpha c_comp c_conf c_capable c_efficient c_intel c_skill, item
 factor c_*, ipf
 
 egen c_scale = rowmean(c_comp c_conf c_capable c_efficient c_intel c_skill)
 label var c_scale "Competence: Scale"
 
 bysort vig_ses: sum c_scale
 bysort vig_race: sum c_scale
 bysort vig_group: sum c_scale
 
 
***********
//warmth alpha=0.9545
***********

 pwcorr w_friendly w_wellint w_trust w_warm w_goodnat w_sincere
 
 alpha w_friendly w_wellint w_trust w_warm w_goodnat w_sincere, item
 factor w_*, ipf
 
 egen w_scale = rowmean(w_friendly w_wellint w_trust w_warm w_goodnat w_sincere)
 label var w_scale "Warmth: Scale"
 
 bysort vig_ses: sum w_scale
 bysort vig_race: sum w_scale
 bysort vig_group: sum w_scale
 
 
****************************************************************
//  save and exit
****************************************************************
	codebook, compact
	
	save "_data/gric-data03-scales.dta", replace

 log close
 exit
