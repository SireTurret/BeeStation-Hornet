/*				MEDICAL OBJECTIVES				*/

/datum/objective/crew/morgue //Ported from old Hippie
	explanation_text = "Ensure the Medbay has been cleaned of any corpses when the shift ends."
	jobs = "chiefmedicalofficer,geneticist,medicaldoctor"

/datum/objective/crew/morgue/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
		if(H.stat == DEAD) // If person is dead and corpse is in one of these areas
			if(get_area(H) == typesof(/area/medical/cryo))
				return FALSE
			if(get_area(H) == typesof(/area/medical/genetics/cloning))
				return FALSE
			if(get_area(H) == typesof(/area/medical/exam_room))
				return FALSE
			if(get_area(H) == typesof(/area/medical/medbay/aft))
				return FALSE
			if(get_area(H) == typesof(/area/medical/medbay/central))
				return FALSE
			if(get_area(H) == typesof(/area/medical/medbay/lobby))
				return FALSE
			if(get_area(H) == typesof(/area/medical/patients_rooms))
				return FALSE
			if(get_area(H) == typesof(/area/medical/sleeper))
				return FALSE
			if(get_area(H) == typesof(/area/medical/storage))
				return FALSE
	return TRUE

/datum/objective/crew/chems //Ported from old Hippie
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have (yell about this on GitHub, something broke) in your bloodstream when the shift ends."
	jobs = "chiefmedicalofficer,chemist"

/datum/objective/crew/chems/New()
	. = ..()
	var/list/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/nicotine, /datum/reagent/medicine, /datum/reagent/medicine/adminordrazine, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/omnizine, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/earthsblood, /datum/reagent/medicine/strange_reagent, /datum/reagent/medicine/changelingadrenaline)
	var/list/drugs = typesof(/datum/reagent/drug) - blacklist
	var/list/meds = typesof(/datum/reagent/medicine) - blacklist
	var/list/chemlist = drugs + meds
	chempath = pick(chemlist)
	targetchem = chempath
	update_explanation_text()

/datum/objective/crew/chems/update_explanation_text()
	. = ..()
	explanation_text = "Have [initial(chempath.name)] in your bloodstream when the shift ends."

/datum/objective/crew/chems/check_completion()
	if(owner.current)
		if(!owner.current.stat == DEAD && owner.current.reagents)
			if(owner.current.reagents.has_reagent(targetchem))
				return TRUE
	else
		return FALSE

/datum/objective/crew/druglordchem //ported from old Hippie with adjustments
	var/targetchem = "none"
	var/datum/reagent/chempath
	var/chemamount = 0
	explanation_text = "Have at least (something broke here) pills containing at least (like really broke) units of (yell on GitHub) when the shift ends."
	jobs = "chemist"

/datum/objective/crew/druglordchem/New()
	. = ..()
	target_amount = rand(5,50)
	chemamount = rand(1,20)
	var/list/blacklist = list(/datum/reagent/drug, /datum/reagent/drug/nicotine, /datum/reagent/medicine, /datum/reagent/medicine/adminordrazine, /datum/reagent/medicine/mine_salve, /datum/reagent/medicine/omnizine, /datum/reagent/medicine/syndicate_nanites, /datum/reagent/medicine/earthsblood, /datum/reagent/medicine/strange_reagent, /datum/reagent/medicine/changelingadrenaline)
	var/list/drugs = typesof(/datum/reagent/drug) - blacklist
	var/list/chemlist = drugs
	chempath = pick(chemlist)
	targetchem = chempath
	update_explanation_text()

/datum/objective/crew/druglordchem/update_explanation_text()
	. = ..()
	explanation_text = "Have at least [target_amount] pills containing at least [chemamount] units of [initial(chempath.name)] when the shift ends."

/datum/objective/crew/druglordchem/check_completion()
	var/pillcount = target_amount
	if(owner.current)
		if(owner.current.contents)
			for(var/obj/item/reagent_containers/pill/P in owner.current.get_contents())
				if(P.reagents.has_reagent(targetchem, chemamount))
					pillcount--
	if(pillcount <= 0)
		return TRUE
	else
		return FALSE

/datum/objective/crew/noinfections
	explanation_text = "Make sure there are no crew members with harmful diseases at the end of the shift."
	jobs = "virologist"

/datum/objective/crew/noinfections/check_completion()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(!H.stat == DEAD)
			if((H.z in SSmapping.levels_by_trait(ZTRAIT_STATION)) || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(H.check_virus() == 2) //Harmful viruses only
					return FALSE
	return TRUE
