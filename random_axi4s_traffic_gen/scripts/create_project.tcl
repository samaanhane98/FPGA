set project_name [lindex $argv 0]
set part [lindex $argv 1]
set src_dir [lindex $argv 2]

puts "Creating Project: $project_name with part $part"
create_project $project_name ./build -part $part

puts "Adding constraints"
add_files -fileset constrs_1 $src_dir/constr.xdc

puts "Recreating block design"
source $src_dir/bd/top.tcl