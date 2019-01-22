mol new
mol addfile waterbox.psf type psf
mol addfile waterbox.dcd type dcd waitfor all

if { [molinfo top get numframes] < 2 } {
    puts "ERROR) This test is meaningful only on trajectories (more than one frame)."
    quit
}

if { 1 } {

    # Test 1: time-varying selection

    set sel [atomselect top "(not hydrogen) and (x > -2.0) and (x < 2.0) and (y > -2.0) and (y < 2.0) and (z > -2.0) and (z < 2.0)"]

    set all [atomselect top "all"]
    ${all} set radius 1.0
    ${all} delete

    set n_frames [molinfo top get numframes]
    set n_waters [list]
    for { set frame 0 } { ${frame} < ${n_frames} } { incr frame } {
        ${sel} frame ${frame}
        ${sel} update
        lappend n_waters [${sel} num]
    }
    set n_waters_ave [expr [vecsum ${n_waters}] / ${n_frames}]

    set res 0.25
    volmap density \
        ${sel} \
        -res ${res} -minmax [list [list -6.0 -6.0 -6.0] [list 6.0 6.0 6.0]] \
        -allframes -combine avg \
        -checkpoint 0 \
        -o water_density.dx

    set f [open "water_density.dx" "r"]
    set integral 0.0
    while { [gets ${f} line] != -1 } {
        set words [split ${line}]
        if { [string is double [lindex ${words} 0]] > 0 } {
            foreach word ${words} {
                set integral [expr ${integral} + ${word}]
            }
        }
    }
    close ${f}
    set integral [expr ${integral}*(${res}*${res}*${res})]

    puts "TEST1 results:"
    puts [format "TEST1) Integral of density map = %.5f" ${integral}]
    puts [format "TEST1) Average number of atoms = %.5f" ${n_waters_ave}]
    
    ${sel} delete

}


if { 2 } {

    # Test 2: time-varying selection and custom weight with fixed property

    set sel [atomselect top "(not hydrogen) and (x > -2.0) and (x < 2.0) and (y > -2.0) and (y < 2.0) and (z > -2.0) and (z < 2.0)"]

    set all [atomselect top "all"]
    ${all} set occupancy 1.0

    set n_frames [molinfo top get numframes]
    set n_waters [list]
    for { set frame 0 } { ${frame} < ${n_frames} } { incr frame } { 
        ${sel} frame ${frame}
        ${sel} update
        lappend n_waters [${sel} num]
    }
    set n_waters_ave [expr [vecsum ${n_waters}] / ${n_frames}]

    set res 0.25
    volmap density \
        ${sel} -weight occupancy \
        -res ${res} -minmax [list [list -6.0 -6.0 -6.0] [list 6.0 6.0 6.0]] \
        -allframes -combine avg \
        -checkpoint 0 \
        -o water_density.dx

    set f [open "water_density.dx" "r"]
    set integral 0.0
    while { [gets ${f} line] != -1 } {
        set words [split ${line}]
        if { [string is double [lindex ${words} 0]] > 0 } {
            foreach word ${words} {
                set integral [expr ${integral} + ${word}]
            }
        }
    }
    close ${f}
    set integral [expr ${integral}*(${res}*${res}*${res})]

    puts "TEST2 results:"
    puts [format "TEST2) Integral of density map = %.5f" ${integral}]
    puts [format "TEST2) Average number of atoms = %.5f" ${n_waters_ave}]
    
    ${sel} delete
    ${all} delete
}


if { 3 } {

    # Test 3: time-varying selection and time-varying custom weight (user)

    set sel [atomselect top "(not hydrogen) and (x > -2.0) and (x < 2.0) and (y > -2.0) and (y < 2.0) and (z > -2.0) and (z < 2.0)"]

    set all [atomselect top "all"]
    ${all} set occupancy 1.0

    set n_frames [molinfo top get numframes]
    set n_waters [list]
    for { set frame 0 } { ${frame} < ${n_frames} } { incr frame } { 
        ${sel} frame ${frame}
        ${sel} update
        ${sel} set user [vecmul [${sel} get x] [${sel} get x]] 
        lappend n_waters [vecsum [${sel} get user]]
    }
    set n_waters_ave [expr [vecsum ${n_waters}] / ${n_frames}]

    set res 0.25
    volmap density \
        ${sel} -weight user \
        -res ${res} -minmax [list [list -6.0 -6.0 -6.0] [list 6.0 6.0 6.0]] \
        -allframes -combine avg \
        -checkpoint 0 \
        -o water_density.dx

    set f [open "water_density.dx" "r"]
    set integral 0.0
    while { [gets ${f} line] != -1 } {
        set words [split ${line}]
        if { [string is double [lindex ${words} 0]] > 0 } {
            foreach word ${words} {
                set integral [expr ${integral} + ${word}]
            }
        }
    }
    close ${f}
    set integral [expr ${integral}*(${res}*${res}*${res})]

    puts "TEST3 results:"
    puts [format "TEST3) Integral of density map = %.5f" ${integral}]
    puts [format "TEST3) Average value of \"user\" = %.5f" ${n_waters_ave}]
    
    ${sel} delete
    ${all} delete
}


if { 4 } {

    # Test 4: time-varying selection and explicit weights

    set sel [atomselect top "(not hydrogen) and (x > -2.0) and (x < 2.0) and (y > -2.0) and (y < 2.0) and (z > -2.0) and (z < 2.0)"]

    set all [atomselect top "all"]

    set weights_all [vecmul [${all} get y] [${all} get z]]
    ${all} set occupancy ${weights_all}

    set n_frames [molinfo top get numframes]
    set n_waters [list]
    for { set frame 0 } { ${frame} < ${n_frames} } { incr frame } { 
        ${sel} frame ${frame}
        ${sel} update
        lappend n_waters [vecsum [${sel} get occupancy]]
    }
    set n_waters_ave [expr [vecsum ${n_waters}] / ${n_frames}]

    set res 0.25
    volmap density \
        ${sel} -weight ${weights_all} \
        -res ${res} -minmax [list [list -6.0 -6.0 -6.0] [list 6.0 6.0 6.0]] \
        -allframes -combine avg \
        -checkpoint 0 \
        -o water_density.dx

    set f [open "water_density.dx" "r"]
    set integral 0.0
    while { [gets ${f} line] != -1 } {
        set words [split ${line}]
        if { [string is double [lindex ${words} 0]] > 0 } {
            foreach word ${words} {
                set integral [expr ${integral} + ${word}]
            }
        }
    }
    close ${f}
    set integral [expr ${integral}*(${res}*${res}*${res})]

    puts "TEST4 results:"
    puts [format "TEST4) Integral of density map = %.5f" ${integral}]
    puts [format "TEST4) Average value of (YxZ)  = %.5f" ${n_waters_ave}]
    
    ${sel} delete
    ${all} delete
}

quit
