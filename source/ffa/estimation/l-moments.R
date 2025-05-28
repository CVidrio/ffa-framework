library(lmom)

# Parameter estimation using the method of L-moments
l_moments <- function(ams, distribution) {

	switch(
		distribution,
		GEV = unname(pelgev(samlmu(ams))),
		GUM = unname(pelgum(samlmu(ams))),
		NOR = unname(pelnor(samlmu(ams))),
		LNO = unname(pelln3(samlmu(ams), bound = 0)),
		GLO = unname(pelglo(samlmu(ams))),
		PE3 = unname(pelpe3(samlmu(ams))),
		LP3 = unname(pelpe3(samlmu(log(ams)))),
		GNO = unname(pelgno(samlmu(ams))),
		WEI = unname(pelwei(samlmu(ams), bound = 0)),
		GPA = unname(pelgpa(samlmu(ams)))
	)
}
