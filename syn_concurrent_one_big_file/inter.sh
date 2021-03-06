directory="mbexp008vs008"
date

generator_num=1
writer_num=1
reader_num=1
block_size=1
# cpt_total_blks=1000
# writer_thousandth=300
computer_group_size=1
num_compute_nodes=8
num_analysis_nodes=8
total_nodes=16
maxp=1
lp=1

echo "------OptNoSt512v128P16s4---------------"
echo "lp=$lp, num_compute_nodes=$num_compute_nodes, num_analysis_nodes=$num_analysis_nodes"
echo "Usage: %s $generator_num $writer_num $reader_num ${block_size[i]} $cpt_total_blks  ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes"
echo "Block size starting from 64KB,128KB,256KB,512KB,1MB,2MB,4MB,8MB"
echo "Block size input =	   1   ,2    ,4    ,8    ,16 ,32 ,64 ,128"
my_run_exp2="aprun -n $total_nodes -N 16 -d 2 /N/u/fuyuan/BigRed2/Openfoam/20160518_test/syn_concurrent/concurrent"
my_del_exp2='time rsync -a --delete-before  /N/dc2/scratch/fuyuan/empty/ '

# rm -rf /N/dc2/scratch/fuyuan/concurrent/syn/$directory/
mkdir /N/dc2/scratch/fuyuan/concurrent/
mkdir /N/dc2/scratch/fuyuan/concurrent/syn/
mkdir /N/dc2/scratch/fuyuan/concurrent/syn/$directory/

date
echo "remove all subdirectories"
echo "-----------Delete files-----------------"
# for ((m=0;m<$num_compute_nodes;m++)); do
#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g" $m)
# done
echo "-----------End Delete files-------------"
# $my_del_exp2  /N/dc2/scratch/fuyuan/concurrent/syn/$directory/
date

# echo "mkdir new"
# for ((m=0;m<$num_compute_nodes; m++)); do
# 	mkdir $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# 	lfs setstripe --count 4 -o -1 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# done
# "/N/dc2/scratch/fuyuan/mb/lbmmix/mbexp%03dvs%03d/cid%03d/cid%03dthrd%02dblk%d.d"


echo
echo
echo "####### Simulate $num_compute_nodes Compute Parallel Write vs $num_analysis_nodes Analysis Parallel Read ########"

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "***********$num_compute_nodes Compute Write*******************************"
echo "Each compute node has 3 threads, generator, writer, sender"
echo "Block size starting from 64KB,128KB,256KB,512KB,1MB,2MB,4MB,8MB"
echo "*********************$num_analysis_nodes Analysis Read**********************"
echo "Each Analysis node has 3 threads, receiver, reader, consumer"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo "-------------------------------------------"
echo "8MB 4MB"
echo "-------------------------------------------"
echo "mkdir new"
for ((m=0;m<$num_compute_nodes; m++)); do
	mkdir $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
	# lfs setstripe --count 4 -o -1 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
done
block_size=(4)
cpt_total_blks=(1000)
writer_thousandth=(20)
# writer_thousandth=(0)
utime=(1000)

for((i=0;i<${#block_size[@]};i++));do
	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
			echo
			echo
			val=`expr ${block_size[i]} \* 64`
			echo "*************************************************************************************"
			echo "---Concurrent write and Read $val KB, cpt_total_blks = ${cpt_total_blks[i]}, writer_thousandth = ${writer_thousandth[k]}------"
			echo "*************************************************************************************"
			# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
			#  		then
			#     		break
			#fi
			for ((p=0; p<$maxp; p++)); do
				echo "=============Loop $p==============="
				echo "setstripe 4"
				echo "utime=${utime[i]}"
				for ((m=0;m<$num_compute_nodes; m++)); do
					# mkdir $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
					lfs setstripe --count 4 -o -1 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
				done
				$my_run_exp2 $generator_num $writer_num $reader_num ${block_size[i]} ${cpt_total_blks[i]}  ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp ${utime[i]}
				# echo "-----------Start Deleting files-------------"
				# for ((m=0;m<$num_compute_nodes;m++)); do
				#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g" $m)
				# done
				# echo "-----------End Delete files-------------"
				echo
			done
	done
done

# echo "-------------------------------------------"
# echo "2MB"
# echo "-------------------------------------------"

# block_size=(32)
# cpt_total_blks=(4000)
# writer_thousandth=(0 50 100 150)
# utime=(50000)

# for((i=0;i<${#block_size[@]};i++));do
# 	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
# 			echo
# 			echo
# 			val=`expr ${block_size[i]} \* 64`
# 			echo "*************************************************************************************"
# 			echo "---Concurrent write and Read $val KB, cpt_total_blks = ${cpt_total_blks[i]}, writer_thousandth = ${writer_thousandth[k]}------"
# 			echo "*************************************************************************************"
# 			# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
# 			#  		then
# 			#     		break
# 			#fi
# 			for ((p=0; p<$maxp; p++)); do
# 				echo "=============Loop $p==============="
# 				echo "setstripe 2"
# 				echo "utime=${utime[i]}"
# 				for ((m=0;m<$num_compute_nodes; m++)); do
# 					# mkdir $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# 					lfs setstripe --count 2 -o -1 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# 				done
# 				$my_run_exp2 $generator_num $writer_num $reader_num ${block_size[i]} ${cpt_total_blks[i]}  ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp ${utime[i]}
# 				# echo "-----------Start Deleting files-------------"
# 				# for ((m=0;m<$num_compute_nodes;m++)); do
# 				#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g" $m)
# 				# done
# 				# echo "-----------End Delete files-------------"
# 				echo
# 			done
# 	done
# done

# echo "-------------------------------------------"
# echo "1MB 512KB 256KB"
# echo "-------------------------------------------"
# # block_size=(16 8 4 2)
# cpt_total_blks=(8000 16000 32000 64000)
# # writer_thousandth=(0 50 100 150)
# # utime=(5000 5000 5000 5000)
# block_size=(16 8 4 2)
# # cpt_total_blks=(8000 1600)
# writer_thousandth=(0 50 100)
# utime=(15000 7500 3750 1875)
# for((i=0;i<${#block_size[@]};i++));do
# 	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
# 			echo
# 			echo
# 			val=`expr ${block_size[i]} \* 64`
# 			echo "*************************************************************************************"
# 			echo "---Concurrent write and Read $val KB, cpt_total_blks = ${cpt_total_blks[i]}, writer_thousandth = ${writer_thousandth[k]}------"
# 			echo "*************************************************************************************"
# 			# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
# 			#  		then
# 			#     		break
# 			#fi
# 			for ((p=0; p<$maxp; p++)); do
# 				echo "=============Loop $p==============="
# 				echo "setstripe 1"
# 				echo "utime=${utime[i]}"
# 				for ((m=0;m<$num_compute_nodes; m++)); do
# 					# mkdir $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# 					lfs setstripe --count 1 -o -1 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g " $m)
# 				done
# 				$my_run_exp2 $generator_num $writer_num $reader_num ${block_size[i]} ${cpt_total_blks[i]}  ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp ${utime[i]}
# 				# echo "-----------Start Deleting files-------------"
# 				# for ((m=0;m<$num_compute_nodes;m++)); do
# 				#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g" $m)
# 				# done
# 				# echo "-----------End Delete files-------------"
# 				echo
# 			done
# 	done
# done
# echo "-----------Start Deleting files-------------"
# # for ((m=0;m<$num_compute_nodes;m++)); do
# #     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/concurrent/syn/$directory/cid%03g" $m)
# # done
# echo "-----------End Delete files-------------"
