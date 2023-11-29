***** Paper: A Half-Century Investigation of Police Officer Line-of-Duty Deaths: Putting the Recent Spike in Long-Term Context 
***** Authors: White, M., Monk, K., Watts, S ***********************************
***** Do-file author: Seth Watts ***********************************************
********************************************************************************
global d "/Users/sethwatts/Dropbox (ASU)/MAIN/Officer Down/Data"
use "$d/ODMP_2017_2021.dta"

*on windows stata station
global d "E:\Officer Down\Data"
use "$d\ODMP_2017_2021.dta"

*dealing with missing data, recoding, renaming, relabeling some vars
recode q6_age (999 = .)
recode q14_ambush (3 = .)
recode q15_swat q16_warrant q17_partners q18_alone q19_spouse q20_children q21_off_duty (2 = .)
recode q23a_s1_sex q23b_s2_sex q23c_s3_sex (3 = .)
recode q24_s1_age q24_s2_age q24_s3_age q27a_s1_warrant q27b_s2_warrant q27c_s3_warrant q28a_s1_felon q28b_s2_felon q28c_s3_felon q29a_s1_parole q29b_s2_parole q29c_s3_parole q30a_s1_gang q30b_s2_gang q30c_s3_gang q31a_s1_suicidal q31b_s2_suicidal q31c_s3_suicidal q32a_s1_mentally_ill q32b_s2_mentally_ill q32c_s3_mentally_ill q33a_s1_drugs q33b_s2_drugs q33c_s3_drugs (2 = .)
*creating decades*
gen decades = .
replace decades = 1 if q5_end_of_watch_yr >= 1970 & q5_end_of_watch_yr <= 1979
replace decades = 2 if q5_end_of_watch_yr >= 1980 & q5_end_of_watch_yr <= 1989
replace decades = 3 if q5_end_of_watch_yr >= 1990 & q5_end_of_watch_yr <= 1999
replace decades = 4 if q5_end_of_watch_yr >= 2000 & q5_end_of_watch_yr <= 2009
replace decades = 5 if q5_end_of_watch_yr >= 2010 & q5_end_of_watch_yr <= 2019
replace decades = 6 if q5_end_of_watch_yr >= 2020 & q5_end_of_watch_yr <= 2021
lab def decades 1 "1970-1979" 2 "1980-1989" 3 "1990-1999" 4 "2000-2009" 5 "2010-2019" 6 "2020-2021" 
lab val decades decades
tab decades
*creating avgerage total officer per decade* sum tot_ofcs if decades == #
gen avg_decade_ofcs = .
replace avg_decade_ofcs = 382931.6 if q5_end_of_watch_yr >= 1970 & q5_end_of_watch_yr <= 1979
replace avg_decade_ofcs = 464981.7 if q5_end_of_watch_yr >= 1980 & q5_end_of_watch_yr <= 1989
replace avg_decade_ofcs = 580225.9 if q5_end_of_watch_yr >= 1990 & q5_end_of_watch_yr <= 1999
replace avg_decade_ofcs = 678910.1 if q5_end_of_watch_yr >= 2000 & q5_end_of_watch_yr <= 2009
replace avg_decade_ofcs = 673323.3 if q5_end_of_watch_yr >= 2010 & q5_end_of_watch_yr <= 2019
replace avg_decade_ofcs = 699376.1 if q5_end_of_watch_yr >= 2020 & q5_end_of_watch_yr <= 2021
lab def avg_decade_ofcs 1 "avg officers, 70-79" 2 "avg officers, 80-89" 3 "avg officers, 90-99" 4 "avg officers, 00-09" 5 "avg officers, 10-19" 6 "avg officers, 20-21" 
lab val avg_decade_ofcs avg_decade_ofcs
tab avg_decade_ofcs
*felonious/nonfelonious*
tab deathtype
*recode fel deaths that need to be non-fel
recode deathtype (1 = 0) if q10_cod == 7 | q10_cod == 12 | q10_cod == 20 | q10_cod == 21 | q10_cod == 28 | q10_cod == 38
recode deathtype (99 =.)
gen felonious = deathtype
tab felonious
gen non_felonious = deathtype
recode non_felonious (0 = 1) (1 = 0)
tab non_felonious
*ambushes*
tab q14_ambush
gen ambush = .
replace ambush = 0 if q14_ambush == 2
replace ambush = 1 if q14_ambush == 1
replace ambush = . if q14_ambush == 0
replace ambush = . if q14_ambush == 3
lab def ambush 0 "non ambush" 1 "ambush"
lab val ambush ambush
tab ambush
*agency type
tab q3_department
gen agency_type = q3_department
lab def agency_type 1 "local/city/town" 2 "county/constable" 3 "state/highway" 4 "federal" 5 "corrections/jail" 6 "other"
lab val agency_type agency_type
*month of incident
tab q9_incident_month
recode q9_incident_month (20 =.)
lab def q9_incident_month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
lab val q9_incident_month q9_incident_month
*state
tab q4_state
lab def q4_state 1 "Alabama" 2 "Alaska" 3 "Arizona" 4 "Arkansas" 5 "California" 6 "Colorado" 7 "Connecticut" 8 "Delaware" 9 "Florida" 10 "Georgia" 11 "Hawaii" 12 "Idaho" 13  "Illinois" 14 "Indiana" 15 "Iowa" 16 "Kansas" 17 "Kentucky" 18 "Louisiana" 19 "Maine" 20 "Maryland" 21 "Massachusetts" 22 "Michigan" 23 "Minnesota" 24 "Mississippi" 25 "Missouri" 26 "Montana" 27 "Nebraska" 28 "Nevada" 29 "New Hampshire" 30 "New Jersey" 31 "New Mexico" 32 "New York"  33 "North Carolina" 34 "North Dakota" 35 "Ohio"  36 "Oklahoma" 37 "Oregon" 38 "Pennsylvania" 39 "Rhode Island" 40 "South Carolina" 41 "South Dakota" 42 "Tennessee" 43 "Texas" 44 "Utah" 45 "Vermont" 46 "Virginia" 47 "Washington" 48 "West Virginia" 49 "Wisconsin" 50 "Wyoming" 51 "American Samoa" 52 "DC" 53 "N Mariana Islands" 54 "Overseas" 55 "Puerto Rico"  56 "Panama Canal" 57 "Railroad police" 58 "Tribal police" 59 "US Government" 60 "Virgin Islands"
lab val q4_state q4_state
*rank
tab q1_rank
lab def q1_rank 1 "front line officer (officer, deputy)" 2 "supervisor" 3 "detective/ investigator" 4 "management (Lt, chief, sheriff)"
lab val q1_rank q1_rank
*tour
tab q7_tour
recode q7_tour (99 = .)
sum q7_tour, det
*age
tab q6_age
sum q6_age, det
*sex --- before 2020 it appears 2 was used for female
tab q2_sex
recode q2_sex (3 = .)
recode q2_sex (2 = 0), gen (sex)
lab def sex 0 "female" 1 "male"
lab val sex sex
tab sex
gen male = sex
gen female = sex
recode female (0 = 1) (1 = 0)
tab male
tab female
*cause of death
tab q10_cod
lab def q10_cod 1 "9/11 related illness" 2 "accidental" 3 "aircraft incident" 4 "animal related" 5 "asphyxiation" 6 "assault" 7 "automobile accident" 8 "bicycle accident" 9 "boating accident" 10 "bomb" 11 "drowned" 12 "duty related illness" 13 "electrocuted" 14 "explosion"  15 "exposure" 16 "exposure to toxins" 17 "fall" 18 "fire" 19 "gunfire" 20 "gunfire (accidental)" 21 "heart attack" 22 "heat exhaustion" 23 "motorcycle accident" 24 "poisoned" 25 "stabbed" 26 "struck by streetcar" 27 "struck by train" 28 "struck by vehicle" 29 "structure collapse" 30 "terrorist attack" 31 "train accident" 32 "training accident" 33 "unidentified" 34 "vehicle pursuit" 35 "vehicular assault" 36 "weather/natural disaster" 37 "other" 38 "COVID-19"
lab val q10_cod q10_cod
*alone, spouse, children, off duty
tab q18_alone
lab def q18_alone 0 "not alone" 1 "alone"
lab val q18_alone q18_alone
tab q19_spouse
lab def q19_spouse 0 "no spouse" 1 "spouse"
lab val q19_spouse q19_spouse
tab q20_children
lab def q20_children 0 "no children" 1 "children"
lab val q20_children q20_children
tab q21_off_duty
lab def q21_off_duty 0 "on duty" 1 "off duty"
lab val q21_off_duty q21_off_duty
*total officer deaths
gen tot_ofc_deaths = 1
*excluding corrections, and other from calculations based on reviewer comments: local, county, state leo only
drop if agency_type == 5 
drop if agency_type == 6
*total officers by year
*https://ucr.fbi.gov/crime-in-the-u.s/2017/crime-in-the-u.s.-2017/topic-pages/tables/table-74
*https://ucr.fbi.gov/crime-in-the-u.s/2018/crime-in-the-u.s.-2018/topic-pages/tables/table-74
*https://ucr.fbi.gov/crime-in-the-u.s/2019/crime-in-the-u.s.-2019/topic-pages/tables/table-74
*https://crime-data-explorer.app.cloud.gov/pages/le/pe https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/le/pe(2020)
gen tot_ofcs = .
replace tot_ofcs = 276056 if q5_end_of_watch_yr == 1970
replace tot_ofcs = 315055 if q5_end_of_watch_yr == 1971
replace tot_ofcs = 383560 if q5_end_of_watch_yr == 1972
replace tot_ofcs = 360818 if q5_end_of_watch_yr == 1973
replace tot_ofcs = 383698 if q5_end_of_watch_yr == 1974
replace tot_ofcs = 411000 if q5_end_of_watch_yr == 1975
replace tot_ofcs = 418000 if q5_end_of_watch_yr == 1976
replace tot_ofcs = 437000 if q5_end_of_watch_yr == 1977
replace tot_ofcs = 431000 if q5_end_of_watch_yr == 1978
replace tot_ofcs = 437000 if q5_end_of_watch_yr == 1979
replace tot_ofcs = 438442 if q5_end_of_watch_yr == 1980
replace tot_ofcs = 444240 if q5_end_of_watch_yr == 1981
replace tot_ofcs = 448927 if q5_end_of_watch_yr == 1982
replace tot_ofcs = 449370 if q5_end_of_watch_yr == 1983
replace tot_ofcs = 467117 if q5_end_of_watch_yr == 1984
replace tot_ofcs = 470678 if q5_end_of_watch_yr == 1985
replace tot_ofcs = 475853 if q5_end_of_watch_yr == 1986
replace tot_ofcs = 480383 if q5_end_of_watch_yr == 1987
replace tot_ofcs = 485566 if q5_end_of_watch_yr == 1988
replace tot_ofcs = 496353 if q5_end_of_watch_yr == 1989
replace tot_ofcs = 523262 if q5_end_of_watch_yr == 1990
replace tot_ofcs = 535629 if q5_end_of_watch_yr == 1991
replace tot_ofcs = 544309 if q5_end_of_watch_yr == 1992
replace tot_ofcs = 553773 if q5_end_of_watch_yr == 1993
replace tot_ofcs = 561543 if q5_end_of_watch_yr == 1994
replace tot_ofcs = 586756 if q5_end_of_watch_yr == 1995
replace tot_ofcs = 595170 if q5_end_of_watch_yr == 1996
replace tot_ofcs = 618127 if q5_end_of_watch_yr == 1997
replace tot_ofcs = 641208 if q5_end_of_watch_yr == 1998
replace tot_ofcs = 637551 if q5_end_of_watch_yr == 1999
replace tot_ofcs = 654601 if q5_end_of_watch_yr == 2000
replace tot_ofcs = 659104 if q5_end_of_watch_yr == 2001
replace tot_ofcs = 665555 if q5_end_of_watch_yr == 2002
replace tot_ofcs = 663796 if q5_end_of_watch_yr == 2003
replace tot_ofcs = 675734 if q5_end_of_watch_yr == 2004
replace tot_ofcs = 673146 if q5_end_of_watch_yr == 2005
replace tot_ofcs = 683396 if q5_end_of_watch_yr == 2006
replace tot_ofcs = 699850 if q5_end_of_watch_yr == 2007
replace tot_ofcs = 708569 if q5_end_of_watch_yr == 2008
replace tot_ofcs = 706886 if q5_end_of_watch_yr == 2009
replace tot_ofcs = 705009 if q5_end_of_watch_yr == 2010
replace tot_ofcs = 698460 if q5_end_of_watch_yr == 2011
replace tot_ofcs = 670439 if q5_end_of_watch_yr == 2012
replace tot_ofcs = 626942 if q5_end_of_watch_yr == 2013
replace tot_ofcs = 627949 if q5_end_of_watch_yr == 2014
replace tot_ofcs = 635781 if q5_end_of_watch_yr == 2015
replace tot_ofcs = 640231 if q5_end_of_watch_yr == 2016
replace tot_ofcs = 670279 if q5_end_of_watch_yr == 2017
*NIBRS data below
replace tot_ofcs = 704744 if q5_end_of_watch_yr == 2018
replace tot_ofcs = 712697 if q5_end_of_watch_yr == 2019
replace tot_ofcs = 718906 if q5_end_of_watch_yr == 2020
replace tot_ofcs = 688138 if q5_end_of_watch_yr == 2021 

********************************************************************************

*re-create fig 1 from CPP paper
collapse (sum) tot_ofc_deaths felonious non_felonious ambush, by(q5_end_of_watch_yr tot_ofcs)

*death rates
gen fel_death_rate = (felonious/tot_ofcs)*100000
gen tot_death_rate = (tot_ofc_deaths/tot_ofcs)*100000
gen nonfel_death_rate = (non_felonious/tot_ofcs)*100000

*poisson reg testing increase in felonious deaths in 2021 (see former Dir. Wray comment)
gen present = 0
recode present (0 = 1) if q5_end_of_watch_yr == 2021
poisson felonious present, exposure(tot_ofcs)

*limit to 2010-2020, 2021
*glm to see dispersion, deviance/residual df = dispersion parameter
glm felonious present if q5_end_of_watch_yr > 2009, family(poisson) exposure(tot_ofcs)
glm felonious present if q5_end_of_watch_yr > 2009, family(nb ml) exposure(tot_ofcs)
poisson felonious present if q5_end_of_watch_yr > 2009, exposure(tot_ofcs)
nbreg felonious i.present if q5_end_of_watch_yr > 2009, exposure(tot_ofcs)
nbreg felonious i.present if q5_end_of_watch_yr > 2009, exposure(tot_ofcs) irr

*testing for serial autocorrelation
*AC, PAC, Q stat
corrgram felonious if q5_end_of_watch_yr > 2009
ac felonious if q5_end_of_watch_yr > 2009

*robustness check, using lags as predictors
gen lag1 = felonious[_n-1]
gen lag2 = felonious[_n-2]
gen lag3 = felonious[_n-3]
gen lag4 = felonious[_n-4]
glm felonious present lag1 lag2 lag3 lag4 if q5_end_of_watch_yr > 2009, family(nb ml) exposure(tot_ofcs)

*felonious deaths post-2009 are normally distributed
reg felonious present if q5_end_of_watch_yr > 2009

*felonious ofc deaths over time
line felonious q5_end_of_watch_yr, lw(medthick)
line fel_death_rate q5_end_of_watch_yr, lw(medthick)
*total, felonious, non-felonious ofc deaths rates over time
line tot_death_rate fel_death_rate nonfel_death_rate q5_end_of_watch_yr, lw(medthick)

********************************************************************************

*COVID 
gen covid = 0
replace covid = 1 if q10_cod == 38
collapse (sum) covid, by(q5_end_of_watch_yr q4_state)
keep if q5_end_of_watch_yr >= 2020

gen state = q4_state
lab val state q4_state
decode state, gen(q4_state1)
merge m:m q4_state1 q5_end_of_watch_yr using "$d/state_skeleton"

*total state LE (2020)
*https://crime-data-explorer.app.cloud.gov/pages/le/pe

tab q4_state, nolab
gen tot_ofcs = .
replace tot_ofcs = 12217 if q4_state == 1 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1290 if q4_state == 2 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 12758 if q4_state == 3 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 6812 if q4_state == 4 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 79636 if q4_state == 5 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 13011 if q4_state == 6 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 7706 if q4_state == 7 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2727 if q4_state == 8 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 4186 if q4_state == 52 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 45852 if q4_state == 9 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 25113 if q4_state == 10 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2896 if q4_state == 11 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 3003 if q4_state == 12 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 26405 if q4_state == 13 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 8211 if q4_state == 14 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 5413 if q4_state1 == "Iowa" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 5661 if q4_state == 16 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 7458 if q4_state == 17 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 6056 if q4_state == 18 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2358 if q4_state == 19 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 16774 if q4_state == 20 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 16719 if q4_state == 21 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 17998 if q4_state == 22 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 9981 if q4_state == 23 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 5147 if q4_state == 24 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 11694 if q4_state == 25 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2119 if q4_state == 26 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 3707 if q4_state == 27 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 7424 if q4_state == 28 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2863 if q4_state == 29 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 38760 if q4_state == 30 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 988 if q4_state == 31 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 57745 if q4_state == 32 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 24508 if q4_state == 33 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1830 if q4_state == 34 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 14082 if q4_state == 35 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 8796 if q4_state == 36 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 6481 if q4_state == 37 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 26013 if q4_state == 38 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2515 if q4_state1 == "Rhode Island" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 11908 if q4_state == 40 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1823 if q4_state == 41 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 17785 if q4_state == 42 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 58723 if q4_state == 43 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 5399 if q4_state == 44 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1203 if q4_state == 45 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 19875 if q4_state == 46 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 10973 if q4_state == 47 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 4119 if q4_state == 48 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 12106 if q4_state == 49 & q5_end_of_watch_yr == 2020
replace tot_ofcs = 12077 if q4_state == 55 & q5_end_of_watch_yr == 2020
***3 year average for 2021
replace tot_ofcs = 11227.333 if q4_state == 1 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1282.333 if q4_state == 2 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 12890.667 if q4_state == 3 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 6897.667 if q4_state == 4 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 79464.333 if q4_state == 5 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 12685.667 if q4_state == 6 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 7592.667 if q4_state == 7 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2454.667 if q4_state == 8 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 4269 if q4_state == 52 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 45638 if q4_state == 9 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 24680 if q4_state == 10 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2834.667 if q4_state == 11 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2969.667 if q4_state == 12 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 27536.667 if q4_state == 13 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 8349.667 if q4_state == 14 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 5185 if q4_state == 15 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 6504.333 if q4_state == 16 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 7421 if q4_state == 17 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 10806.333 if q4_state == 18 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2336.333 if q4_state == 19 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 16906 if q4_state == 20 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 16595 if q4_state == 21 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 17786.667 if q4_state == 22 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 10037.333 if q4_state == 23 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 3569.667 if q4_state == 24 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 13627 if q4_state == 25 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2045 if q4_state == 26 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 3755.667 if q4_state == 27 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 6418.333 if q4_state == 28 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2848 if q4_state == 29 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 36127 if q4_state == 30 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1830.667 if q4_state == 31 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 60806.333 if q4_state == 32 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 24275 if q4_state == 33 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1791.667 if q4_state == 34 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 13855.333 if q4_state == 35 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 8948.333 if q4_state == 36 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 6504.333 if q4_state == 37 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 25724.667 if q4_state == 38 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2516.333 if q4_state == 39 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 12061.333 if q4_state == 40 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1781.667 if q4_state == 41 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 17624.667 if q4_state == 42 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 51913.333 if q4_state == 43 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 5241.667 if q4_state == 44 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1338 if q4_state == 45 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 19508.667 if q4_state == 46 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 10940.667 if q4_state == 47 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 4108.333 if q4_state == 48 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 12583.667 if q4_state == 49 & q5_end_of_watch_yr == 2021
replace tot_ofcs = 12232.333 if q4_state == 55 & q5_end_of_watch_yr == 2021
***tot officers for skeleton states
replace tot_ofcs = 1290 if q4_state1 == "Alaska" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1282.333 if q4_state1 == "Alaska" & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2727 if q4_state1 == "Delaware" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2834.667 if q4_state1 == "Hawaii" & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2969.667 if q4_state1 == "Idaho" & q5_end_of_watch_yr == 2021
replace tot_ofcs = 2358 if q4_state1 == "Maine" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 16774 if q4_state1 == "Maryland" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2119 if q4_state1 == "Montana" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 2863 if q4_state1 == "New Hampshire" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 6481 if q4_state1 == "Oregon" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1781.667 if q4_state1 == "South Dakota" & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1203 if q4_state1 == "Vermont" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1338 if q4_state1 == "Vermont" & q5_end_of_watch_yr == 2021
replace tot_ofcs = 1534 if q4_state1 == "Wyoming" & q5_end_of_watch_yr == 2020
replace tot_ofcs = 1477.667 if q4_state1 == "Wyoming" & q5_end_of_watch_yr == 2021

drop if tot_ofcs == . 
gen covid_rate = (covid * 1000) / tot_ofcs

*separate datasets
keep if q5_end_of_watch_yr == 2020
keep if q5_end_of_watch_yr == 2021
*Export to excel sheets, use new state variable as indicator var and place in first col (delete vars not needed -- prev state variable)

********************************************************************************
*table-making for felonious, non-felonious, and covid code
*need to dichotomize each variable to get stats
recode agency_type (1 = 1) (2/6 = 0), gen(local_agency)
recode agency_type (2 = 1) (1 = 0) (3/6 = 0), gen(county_agency)
recode agency_type (3 = 1) (1/2 = 0) (4/6 = 0), gen(state_agency)
recode agency_type (4 = 1) (1/3 = 0) (5/6 = 0), gen(federal)
recode agency_type (5 = 1) (1/4 = 0) (6 = 0), gen(corrections)
recode agency_type (6 = 1) (1/5 = 0), gen(other)

recode q1_rank (1 = 1) (2/4 = 0), gen(front_line)
recode q1_rank (2 = 1) (1 = 0) (3/4 = 0), gen(supervisor)
recode q1_rank (3 = 1) (1/2 = 0) (4 = 0), gen(detective)
recode q1_rank (4 = 1) (1/3 = 0), gen(management)

recode q5_end_of_watch_mo (1 = 1) (2/12 = 0), gen(january)
recode q5_end_of_watch_mo (2=1) (1=0) (3/12=0), gen(febuary)
recode q5_end_of_watch_mo (3=1) (1/2=0) (4/12=0), gen(march)
recode q5_end_of_watch_mo (4=1) (1/3=0) (5/12=0), gen(april)
recode q5_end_of_watch_mo (5=1) (1/4=0) (6/12=0), gen(may)
recode q5_end_of_watch_mo (6=1) (1/5=0) (7/12=0), gen(june)
recode q5_end_of_watch_mo (7=1) (1/6=0) (8/12=0), gen(july)
recode q5_end_of_watch_mo (8=1) (1/7=0) (9/12=0), gen(august)
recode q5_end_of_watch_mo (9=1) (1/8=0) (10/12=0), gen(september)
recode q5_end_of_watch_mo (10=1) (1/9=0) (11/12=0), gen(october)
recode q5_end_of_watch_mo (11=1) (1/10=0) (12=0), gen(november)
recode q5_end_of_watch_mo (12=1) (1/11=0), gen(december)

recode decades (1=1) (2/6=0) , gen(decade70_79)
recode decades (2=1) (1=0) (3/6=0), gen(decade80_89)
recode decades (3=1) (1/2=0) (4/6=0), gen(decade90_99)
recode decades (4=1) (1/3=0) (5/6=0), gen(decade00_09)
recode decades (5=1) (1/4=0) (6=0), gen(decade10_19)
recode decades (6=1) (1/5=0), gen(decade20_21)

gen assault = q10_cod if q10_cod == 6
recode assault (6 = 1) (.=0), gen(assault1)
gen gunfire = q10_cod if q10_cod == 19
recode gunfire (19=1) (.=0), gen(gunfire1)
gen stabbed = q10_cod if q10_cod == 25
recode stabbed (25=1) (.=0), gen(stabbed1)
gen terrorist_attack = q10_cod if q10_cod == 30
recode terrorist_attack (30=1) (.=0), gen(terrorist_attack1)
gen vehicle_pursuit = q10_cod if q10_cod == 34
recode vehicle_pursuit (34=1) (.=0), gen(vehicle_pursuit1)
gen vehicular_ass = q10_cod if q10_cod == 35
recode vehicular_ass (35=1) (.=0), gen(vehicular_ass1)
gen other_cause = q10_cod if q10_cod != 35 & q10_cod != 34 & q10_cod != 30 & q10_cod != 25 & q10_cod != 19 & q10_cod != 6 
recode other_cause (1/38 =1) (.=0), gen(other_cause1)

gen aircraft = q10_cod if q10_cod == 3
recode aircraft (3 = 1) (.=0), gen(aircraft1)
gen auto_bike_acc = q10_cod 
recode auto_bike_acc (7 23 = 1) (1/38=0), gen(auto_bike_acc1)
gen gun_acc = q10_cod if q10_cod == 20
recode gun_acc (20 = 1) (.=0), gen(gun_acc1)
gen heart_attack = q10_cod if q10_cod == 21
recode heart_attack (21 = 1) (.=0), gen(heart_attack1)
gen struckby_veh = q10_cod if q10_cod == 28
recode struckby_veh (28=1) (.=0), gen(struckby_veh1)
gen drowned = q10_cod if q10_cod == 11
recode drowned (11=1) (.=0), gen(drowned1)
gen other_cause2 = q10_cod if q10_cod != 3 & q10_cod != 7 & q10_cod != 23 & q10_cod != 20 & q10_cod != 21 & q10_cod != 28 & q10_cod != 11
recode other_cause2 (1/38 = 1) (.=0), gen(other_cause3)

label var local_agency "local"
label var county_agency "county"
label var state_agency "state"
label var federal "federal"
label var corrections "corrections"
label var other "other agency"
label var january "january"
label var febuary "febuary"
label var march "march"
label var april "april"
label var may "may"
label var june "june"
label var july "july"
label var august "august"
label var september "september"
label var october "october"
label var november "november"
label var december "december"
label var sex "sex"
label var assault1 "assault"
label var gunfire1 "gunfire"
label var stabbed1 "stabbed"
label var terrorist_attack1 "terrorist attack"
label var vehicle_pursuit1 "vehicle pursuit"
label var vehicular_ass1 "vehicular assault"
label var other_cause1 "other cause"
label var q18_alone "alone during incident"
label var q19_spouse "survived by spouse"
label var q20_children "survived by children"
label var q21_off_duty "off-duty during incident"
label var q6_age "age"
label var front_line "front line"
label var supervisor "supervisor"
label var detective "detective"
label var management "management"
label var q7_tour "length of service"
label var aircraft1 "aircraft incident"
label var struckby_veh1 "struck by vehicle"
label var heart_attack1 "heart attack"
label var drowned1 "drowned"
label var gun_acc1 "gunfire (accidental)"
label var other_cause3 "other"
label var auto_bike_acc1 "auto/motorcycle accident" 
label var male "male"
label var female "female"


*death rates foreach var by decade* NOT USED
foreach var of varlist local_agency county_agency state_agency front_line supervisor detective management male female assault1 gunfire1 stabbed1 terrorist_attack1 vehicle_pursuit1 vehicular_ass1 other_cause1 q21_off_duty {
	gen `var'_rate = (`var'/avg_decade_ofcs)*100000 
	}
	
*starting the table making

***************felonious deaths
tempfile ss //generate tempfile
putexcel set `ss' //set stata to write to tempfile via putexcel command
local row=2 //creating a local to tell stata which row you want it to start writing to in excel

foreach v in local_agency county_agency state_agency federal front_line supervisor detective management male female assault1 gunfire1 stabbed1 terrorist_attack1 vehicle_pursuit1 vehicular_ass1 other_cause1 q21_off_duty {

	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if deathtype == 1 & decade70_79 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the sum in column B
	
	sum `v' if deathtype == 1 & decade80_89 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel D`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel E`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade90_99 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel F`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel G`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade00_09 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel H`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel I`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade10_19 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel J`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel K`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel L`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel M`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel N`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel O`row' = "`sum'" //putting the mean in column B	
	
	local ++row	
	
}

foreach v in q6_age q7_tour {
	
	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if deathtype == 1 & decade70_79 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the sum in column B
	
	sum `v' if deathtype == 1 & decade80_89 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel D`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel E`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade90_99 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel F`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel G`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade00_09 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel H`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel I`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade10_19 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel J`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel K`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel L`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel M`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel N`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel O`row' = "`sum'" //putting the mean in column B
	
	local ++row	
}

copy `ss' "$d/ODMP_table_output_felonious.xlsx", replace
************

************non-felonious deaths
tempfile ss //generate tempfile
putexcel set `ss' //set stata to write to tempfile via putexcel command
local row=2 //creating a local to tell stata which row you want it to start writing to in excel

foreach v in local_agency county_agency state_agency federal front_line supervisor detective management male female aircraft1 auto_bike_acc1 gun_acc1 heart_attack1 struckby_veh1 drowned1 other_cause3 q21_off_duty {

	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if deathtype == 0 & decade70_79 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the sum in column B
	
	sum `v' if deathtype == 0 & decade80_89 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel D`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel E`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade90_99 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel F`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel G`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade00_09 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel H`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel I`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade10_19 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel J`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel K`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel L`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel M`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel N`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel O`row' = "`sum'" //putting the mean in column B	
	
	local ++row	
	
}

foreach v in q6_age q7_tour {
	
	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if deathtype == 0 & decade70_79 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the sum in column B
	
	sum `v' if deathtype == 0 & decade80_89 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel D`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel E`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade90_99 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel F`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel G`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade00_09 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel H`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel I`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade10_19 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel J`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel K`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel L`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel M`row' = "`sum'" //putting the mean in column B
	
	sum `v' if deathtype == 0 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel N`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel O`row' = "`sum'" //putting the mean in column B	
	
	local ++row	
}

copy `ss' "$d/ODMP_table_output_nonfelonious.xlsx", replace
***************

**************COVID only
tempfile ss //generate tempfile
putexcel set `ss' //set stata to write to tempfile via putexcel command
local row=2 //creating a local to tell stata which row you want it to start writing to in excel

foreach v in local_agency county_agency state_agency federal corrections other january febuary march april may june july august september october november december front_line supervisor detective management sex q18_alone q19_spouse q20_children q21_off_duty {

	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if q10_cod == 38 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(sum) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the mean in column B
	
	local ++row	
	
}

foreach v in q6_age q7_tour {
	
	local vtitle : var label `v' //capturing what you named the variable
	putexcel A`row'= "`vtitle'" //putting that var label in the A column and associated row
	
	sum `v' if q10_cod == 38 & decade20_21 == 1 //capturing the summary statistics as scalars for the variable
	local mean : display %4.3f r(mean) //formating how I want the mean displayed: 3 decimal places
	putexcel B`row' = "`mean'" //putting the mean in column B
	local sum : display %4.3f r(N) //formating how I want the sum displayed: 3 decimal places
	putexcel C`row' = "`sum'" //putting the mean in column B
	
	local ++row	
}

copy `ss' "$d/ODMP_table_output_covid.xlsx", replace

********************************************************************************



*monthly deaths over time
collapse (sum) felonious non_felonious tot_ofc_deaths, by(q5_end_of_watch_mo q5_end_of_watch_yr)
gen tot_ofcs = .
replace tot_ofcs = 276056 if q5_end_of_watch_yr == 1970
replace tot_ofcs = 315055 if q5_end_of_watch_yr == 1971
replace tot_ofcs = 383560 if q5_end_of_watch_yr == 1972
replace tot_ofcs = 360818 if q5_end_of_watch_yr == 1973
replace tot_ofcs = 383698 if q5_end_of_watch_yr == 1974
replace tot_ofcs = 411000 if q5_end_of_watch_yr == 1975
replace tot_ofcs = 418000 if q5_end_of_watch_yr == 1976
replace tot_ofcs = 437000 if q5_end_of_watch_yr == 1977
replace tot_ofcs = 431000 if q5_end_of_watch_yr == 1978
replace tot_ofcs = 437000 if q5_end_of_watch_yr == 1979
replace tot_ofcs = 438442 if q5_end_of_watch_yr == 1980
replace tot_ofcs = 444240 if q5_end_of_watch_yr == 1981
replace tot_ofcs = 448927 if q5_end_of_watch_yr == 1982
replace tot_ofcs = 449370 if q5_end_of_watch_yr == 1983
replace tot_ofcs = 467117 if q5_end_of_watch_yr == 1984
replace tot_ofcs = 470678 if q5_end_of_watch_yr == 1985
replace tot_ofcs = 475853 if q5_end_of_watch_yr == 1986
replace tot_ofcs = 480383 if q5_end_of_watch_yr == 1987
replace tot_ofcs = 485566 if q5_end_of_watch_yr == 1988
replace tot_ofcs = 496353 if q5_end_of_watch_yr == 1989
replace tot_ofcs = 523262 if q5_end_of_watch_yr == 1990
replace tot_ofcs = 535629 if q5_end_of_watch_yr == 1991
replace tot_ofcs = 544309 if q5_end_of_watch_yr == 1992
replace tot_ofcs = 553773 if q5_end_of_watch_yr == 1993
replace tot_ofcs = 561543 if q5_end_of_watch_yr == 1994
replace tot_ofcs = 586756 if q5_end_of_watch_yr == 1995
replace tot_ofcs = 595170 if q5_end_of_watch_yr == 1996
replace tot_ofcs = 618127 if q5_end_of_watch_yr == 1997
replace tot_ofcs = 641208 if q5_end_of_watch_yr == 1998
replace tot_ofcs = 637551 if q5_end_of_watch_yr == 1999
replace tot_ofcs = 654601 if q5_end_of_watch_yr == 2000
replace tot_ofcs = 659104 if q5_end_of_watch_yr == 2001
replace tot_ofcs = 665555 if q5_end_of_watch_yr == 2002
replace tot_ofcs = 663796 if q5_end_of_watch_yr == 2003
replace tot_ofcs = 675734 if q5_end_of_watch_yr == 2004
replace tot_ofcs = 673146 if q5_end_of_watch_yr == 2005
replace tot_ofcs = 683396 if q5_end_of_watch_yr == 2006
replace tot_ofcs = 699850 if q5_end_of_watch_yr == 2007
replace tot_ofcs = 708569 if q5_end_of_watch_yr == 2008
replace tot_ofcs = 706886 if q5_end_of_watch_yr == 2009
replace tot_ofcs = 705009 if q5_end_of_watch_yr == 2010
replace tot_ofcs = 698460 if q5_end_of_watch_yr == 2011
replace tot_ofcs = 670439 if q5_end_of_watch_yr == 2012
replace tot_ofcs = 626942 if q5_end_of_watch_yr == 2013
replace tot_ofcs = 627949 if q5_end_of_watch_yr == 2014
replace tot_ofcs = 635781 if q5_end_of_watch_yr == 2015
replace tot_ofcs = 640231 if q5_end_of_watch_yr == 2016
replace tot_ofcs = 673477 if q5_end_of_watch_yr == 2017
replace tot_ofcs = 704744 if q5_end_of_watch_yr == 2018
replace tot_ofcs = 712697 if q5_end_of_watch_yr == 2019
replace tot_ofcs = 718906 if q5_end_of_watch_yr == 2020
replace tot_ofcs = 688138 if q5_end_of_watch_yr == 2021 

sort q5_end_of_watch_yr q5_end_of_watch_mo
gen modate = ym(q5_end_of_watch_yr, q5_end_of_watch_mo)
format modate %tm

gen tot_death_rate = ((tot_ofc_deaths * 100000) / tot_ofcs)
gen fel_death_rate = ((felonious * 100000) / tot_ofcs)
gen nonfel_death_rate = ((non_felonious * 100000) / tot_ofcs)

*exclude september, 2001
line nonfel_death_rate modate, lw(medthick) title("Monthly Non-felonious line-of-duty deaths and death rates, 1970-2021", size(small))	


********************************************************************************
**checking correlation between death rate and vacc rate at the state level
use "$d/state_vacc.dta"
pwcorr covid_rate_2020 covid_rate_2021 covid_rate_2year vacc, star(.01, 05) b
