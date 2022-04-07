#!/bin/bash

[ -z "$EXECNAME" ] && exit 1

[ ! -v opterr ] && opterr=1
optopt=
optind=0
optarg=
optret=

no_argument=0
required_argument=1
optional_argument=2

compound_argument=

getopt() {
	argc=$1
	argv=$2
	shortopts=$3
	optret="0"

	[ ${shortopts:0:1} == ":" ] && opterror=":" || opterror="?"

	if [ -z "$compound_argument" ]; then
		if [ $optind -gt $argc ]; then
			optret="-1"
			return 1
		fi
		optptr="${argv[$optind]}"
		((optind++))

		if [ "$optptr" == "--" ]; then
			optret="-1"
			return 1
		fi

		if [[ $optptr != -* ]]; then
			((optind--))
			optret="-1"
			return 1
		fi

		optptr=${optptr##-}
	else
		optptr="$compound_argument"
	fi

	optopt=${optptr:0:1}
	optarg=${optptr:1}

	if [ -z $optopt ]; then
		optret="-1"
		return 1
	fi

	optmatch=$(echo "$shortopts" | grep -oe "${optopt}\\(:\\+\\)\\?")

	if [ -z $optmatch ]; then
		optret="?"
		return 0
	fi

	if [ ${#optmatch} -eq 2 ]; then
		compound_argument=
		if [ -z $optarg ]; then
			if [ $optind -gt $argc ]; then
				optret="-1"
				return 1
			fi
			optarg=${argv[$optind]}
			((optind++))
			if [ -z $optarg ]; then
				optret=$opterror
				return 1
			fi
		fi
	elif [ ${#optmatch} -eq 3 ]; then
		compound_argument=
		if [ -z $optarg ]; then
			if [ $optind -lt $argc ]; then
				optarg=${argv[$optind]}
				if [ "${optarg:0:1}" == "-" ]; then
					optarg=
				else
					((optind++))
				fi
			fi
		fi
	else
		compound_argument=$optarg
		optarg=
	fi

	optret=$optopt
	return 0
}

getopt_long() {
	argc=$1
	argv=$2
	shortopts=$3
	longopts=$4
	optret="0"

	[ ${shortopts:0:1} == ":" ] && opterror=":" || opterror="?"

	if [ $optind -gt $argc ]; then
		optret="-1"
		return 1
	fi
	optptr=${argv[$optind]}
	((optind++))

	if [ "$optptr" == "--" ]; then
		optret="-1"
		return 1
	fi

	if [[ $optptr != --* ]]; then
		((optind--))
		getopt $argc $argv $shortopts
		return "$?"
	fi

	optptr=${optptr##-}

	echo $optptr | IFS='=' read -r optopt optarg

	if [ -z $optopt ];then
		optret="-1"
		return 1
	fi

	for optdef in $longopts; do
		echo "$optdef" | IFS=':' read -r optdef_opt optdef_arg optdef_flag optdef_val

		if [ $optopt == $optdef_opt ]; then
			case $optdef_arg in
				$no_argument)
					optarg=
					;;
				$required_argument)
					if [ -z $optarg ]; then
						if [ $optind -ge $argc ]; then
							optret="-1"
							return 1
						fi
						optarg=${argv[$optind]}
						((optind++))
						if [ -z $optarg ]; then
							optret=$opterror
							return 1
						fi
					fi
					;;
				$optional_argument)
					if [ -z $optarg ]; then
						if [ $optind -lt $argc ]; then
							optarg=${argv[$optind]}
							if [ ${optarg:0:1} == "-" ]; then
								optarg=
							else
								((optind++))
							fi
						fi
					fi
					;;
			esac

			if [ -z $optdef_flag ]; then
				optret=$optdef_val
				return 0
			fi

			local -n ref=$optdef_flag
			ref=$optdef_val

			return 0
		fi
	done

	optret="?"
	return 0
}

#getopt_long_only() {
#}

checkfile() {
	_INPUT=$1
	shift
	until [ -z "$1" ]; do
		_OPTION=$1
		shift
		case $_OPTION in
			a)  [[ "$_INPUT" != /* ]] && >&2 echo "$EXECNAME: path '$_INPUT' must be absolute" && return 1;;
			d)  [ ! -d "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' must be a directory" && return 1;;
			f)  [ ! -f "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' must be a file" && return 1;;
			r)  [ ! -r "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' doesn't exist or isn't readable" && return 1;;
			w)  [ ! -w "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' doesn't exist or isn't writable" && return 1;;
			x)  [ ! -x "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' doesn't exist or isn't executable" && return 1;;
			*)  [ ! -a "$_INPUT" ] && >&2 echo "$EXECNAME: '$_INPUT' doesn't exist" && return 1;;
		esac
	done
	return 0
}

yesno_yes=

yesno() {
	echo -n "$1 "
	case $2 in
		[Nn]*)  echo -n "[y/N] "; default=1;;
		*)      echo -n "[Y/n] "; default=0;;
	esac
	if $yesno_yes; then
		echo "y"
		return 0
	else
		read -p "" answer
		case $answer in
			[Yy]*)  return 0;;
			[Nn]*)  return 1;;
		esac
	fi
	return $default
}

