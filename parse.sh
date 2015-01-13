#!/bin/bash

STATE=q
CONT=

COUNT=0

rm -r qa-*.txt

while read line; do
	case "$STATE" in
	q)
		if ! [[ "$line" ]]; then continue; fi

		if [[ "$line" == "[–]lennart-poettering"* ]]; then
			echo ""
			STATE=a
			CONT=
		else
			if ! (( CONT )); then
				exec > qa-$(printf "%02d" "$(( ++COUNT ))").txt
				echo "Q:"
				CONT=1
			fi

			echo "$line"
		fi
		;;

	a)
		if [[ "$line" == "----"* ]] || [[ "$line" == "===="* ]]; then
			echo ""
			echo "----"
			echo ""
			STATE=tr_q
			CONT=
		else
			if ! (( CONT )); then
				echo "A:"
				CONT=1
			fi

			echo "$line"
		fi
		;;

	tr_q)
		echo "Q:"
		echo "$line"
		echo ""
		STATE=tr_a
		;;

	tr_a)
		if [[ -z "$line" ]]; then
			echo ""
			STATE=q
			CONT=
		else
			if ! (( CONT )); then
				echo "A:"
				CONT=1
			fi

			echo "$line"
		fi
		;;

	*)
		echo "WRONG STATE: $STATE" >&2
		exit 1
	esac
done