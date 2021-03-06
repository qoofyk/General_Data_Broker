directory="mbexp008vs002"
date

compute_generator_num=1
compute_writer_num=1
analysis_reader_num=1
analysis_writer_num=1
# block_size=1
# cpt_total_blks=1000
computer_group_size=4
num_compute_nodes=8
num_analysis_nodes=2
total_nodes=10
maxp=1
lp=1

echo "------Optimisation----syn_concurrent_store_080vs080_1M8P---------------"
echo "lp=$lp,num_compute_nodes=$num_compute_nodes, num_analysis_nodes=$num_analysis_nodes"
echo "Usage: %s $compute_generator_num $analysis_writer_num {block_size[i]} {cpt_total_blks[i]}  $computer_group_size $num_analysis_nodes"
echo "Block size starting from 64KB,128KB,256KB,512KB,1MB,2MB,4MB,8MB"
echo "Block size input =	   1   ,2    ,4    ,8    ,16 ,32 ,64 ,128"
my_run_exp2="aprun -n $total_nodes -N 1 -d 32 /N/u/fuyuan/BigRed2/Openfoam/20160518_test/syn_concurrent_store/syn_concurrent_store"
my_del_exp2='time rsync -a --delete-before  /N/dc2/scratch/fuyuan/empty/ '

# rm -rf /N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/
mkdir /N/dc2/scratch/fuyuan/store
mkdir /N/dc2/scratch/fuyuan/store/syn_concurrent_store
mkdir /N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/
date
echo "remove all subdirectories"
echo "-----------Delete files-----------------"
# for ((m=0;m<$num_compute_nodes;m++)); do
#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g" $m)
# done
echo "-----------End Delete files-------------"
# $my_del_exp2  /N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/
date
echo "mkdir new"
for ((m=0;m<$num_compute_nodes; m++)); do
	mkdir $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g " $m)
	# lfs setstripe --count 4 -o -1 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g " $m)
done

echo
echo
echo "####### Simulate $num_compute_nodes Compute Parallel Write vs $num_analysis_nodes Analysis Parallel Read ########"

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "***********$num_compute_nodes Compute Write*******************************"
echo "Each compute node has 1 thread, each thread will write according to NUM_ITER and num_blks"
echo "Block size starting from 64KB,128KB,256KB,512KB,1MB,2MB,4MB,8MB"
echo "block_size =	   			1  ,    2,    4,    8, 16, 32, 64,128"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "*********************$num_analysis_nodes Analysis Read**********************"
echo "Each Analysis node has 1 thread, each thread will read according to NUM_ITER and num_blks"
echo "Block size starting from 64KB,128KB,256KB,512KB,1MB,2MB,4MB,8MB"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

# # block_size=(1 2 4 8 16 32 64 128)
# # cpt_total_blks=(2000 2000 2000 2000 2000 2000 2000 2000)
# # cpt_total_blks=(12800 6400 3200 1600 8000 4000 2000 1000)
# # writer_thousandth=(0 50 100 200 300)

# # block_size=(8 16 32 64 128)
# # cpt_total_blks=(1600 8000 4000 2000 1000)
# # writer_thousandth=(0 50 100 200 300 400)

# block_size=(128 64)
# cpt_total_blks=(500 1000)
# writer_thousandth=(0 50 100 200 300)
block_size=(128)
cpt_total_blks=(500)
writer_thousandth=(600)
utime=0
for((i=0;i<${#block_size[@]};i++));do
	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
		echo
		echo
		val=`expr ${block_size[i]} \* 64`
		echo "*************************************************************************************"
		echo "---syn_concurrent_store $val KB, cpt_total_blks=${cpt_total_blks[i]},  writer_thousandth = ${writer_thousandth[k]}------"
		echo "*************************************************************************************"
		# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
		#  		then
		#     		break
		#fi
		for ((p=0; p<$maxp; p++)); do
			echo "=============Loop $p==============="
			for ((m=0;m<$num_compute_nodes; m++)); do
				lfs setstripe --count 4 -o -1 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g " $m)
			done
			$my_run_exp2 $compute_generator_num $compute_writer_num $analysis_reader_num $analysis_writer_num ${block_size[i]} ${cpt_total_blks[i]} ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp $utime
			# echo "-----------Start Deleting files-------------"
			# for ((m=0;m<$num_compute_nodes;m++)); do
			#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g" $m)
			# done
			# echo "-----------End Delete files-------------"
			echo
		done
	done
done

# block_size=(32)
# cpt_total_blks=(2000)
# writer_thousandth=(0 50 100 200 300)

# utime=0
# for((i=0;i<${#block_size[@]};i++));do
# 	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
# 		echo
# 		echo
# 		val=`expr ${block_size[i]} \* 64`
# 		echo "*************************************************************************************"
# 		echo "---syn_concurrent_store $val KB, cpt_total_blks=${cpt_total_blks[i]},  writer_thousandth = ${writer_thousandth[k]}------"
# 		echo "*************************************************************************************"
# 		# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
# 		#  		then
# 		#     		break
# 		#fi
# 		for ((p=0; p<$maxp; p++)); do
# 			echo "=============Loop $p==============="
# 			for ((m=0;m<$num_compute_nodes; m++)); do
# 				lfs setstripe --count 2 -o -1 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g " $m)
# 			done
# 			$my_run_exp2 $compute_generator_num $compute_writer_num $analysis_reader_num $analysis_writer_num ${block_size[i]} ${cpt_total_blks[i]} ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp $utime
# 			# echo "-----------Start Deleting files-------------"
# 			# for ((m=0;m<$num_compute_nodes;m++)); do
# 			#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g" $m)
# 			# done
# 			# echo "-----------End Delete files-------------"
# 			echo
# 		done
# 	done
# done

# block_size=(16 8 4 2)
# cpt_total_blks=(4000 8000 16000 32000)
# writer_thousandth=(0 100 200 300)
# # block_size=(2)
# # cpt_total_blks=(500)
# # writer_thousandth=(700)
# utime=0
# for((i=0;i<${#block_size[@]};i++));do
# 	for ((k=0; k<${#writer_thousandth[@]}; k++)); do
# 		echo
# 		echo
# 		val=`expr ${block_size[i]} \* 64`
# 		echo "*************************************************************************************"
# 		echo "---syn_concurrent_store $val KB, cpt_total_blks=${cpt_total_blks[i]},  writer_thousandth = ${writer_thousandth[k]}------"
# 		echo "*************************************************************************************"
# 		# if [ $val -eq 64 ] && [ $val -eq 128 ] && [ $val -eq 16384 ]
# 		#  		then
# 		#     		break
# 		#fi
# 		for ((p=0; p<$maxp; p++)); do
# 			echo "=============Loop $p==============="
# 			for ((m=0;m<$num_compute_nodes; m++)); do
# 				lfs setstripe --count 1 -o -1 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g " $m)
# 			done
# 			$my_run_exp2 $compute_generator_num $compute_writer_num $analysis_reader_num $analysis_writer_num ${block_size[i]} ${cpt_total_blks[i]} ${writer_thousandth[k]} $computer_group_size $num_analysis_nodes $lp $utime
# 			# echo "-----------Start Deleting files-------------"
# 			# for ((m=0;m<$num_compute_nodes;m++)); do
# 			#     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g" $m)
# 			# done
# 			# echo "-----------End Delete files-------------"
# 			echo
# 		done
# 	done
# done

# echo "-----------Start Deleting files-------------"
# # for ((m=0;m<$num_compute_nodes;m++)); do
# #     $my_del_exp2 $(printf "/N/dc2/scratch/fuyuan/store/syn_concurrent_store/$directory/cid%03g" $m)
# # done
# echo "-----------End Delete files-------------"
