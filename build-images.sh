function build-images(){
	for F in $(ls $1/*)
	do
		echo "$F to png"
		silicon $F --output "$F.png" --theme TwoDark --background '#fff0' --no-window-controls
	done
}
