#minute	hour	mday	month	wday	command
#
# Run convert.sh once a minute
*	*	*	*	*	nice -n 10 @WWW_ROOT_FS@/orc/convert.sh
# Delete the incoming directory once per month at 2:03am
3	2	10	*	*	@WWW_ROOT_FS@/orc/clean.sh
