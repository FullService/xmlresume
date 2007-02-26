#minute	hour	mday	month	wday	command
#
# Run convert.sh once a minute
*	*	*	*	*	nice -n 10 @WWW_ROOT_FS@/orc/convert.sh
# Delete the incoming directory every month
3	2	15	*	*	@WWW_ROOT_FS@/orc/clean.sh
