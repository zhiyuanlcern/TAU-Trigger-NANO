


tag="2018_2p1_test_bothtau"
Data="Data_2018_tagmuon.root"
MC="MC_2018_tagmuon.root"

python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}giventau_2 --conditional 1  --decay-modes all,0,1,1011   --channels mutau > ${tag}nohup-createTurnOn.log  &
python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}tau_2 --conditional 0  --decay-modes all,0,1,1011  --channels mutau > ${tag}nohup-createTurnOn.log  &
# nohup python3 fitTurnOn.py --input Plot/${tag}giventau_2.root --output Plot/${tag}fitTurnOn --channels mutau --decay-modes all,0,1,1011  > ${tag}nohup-fitTurnOn.log 2>&1 &
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_data  --channels mutau --decay-modes all,0,1,1011 --mc 0 >  ${tag}nohup-compare.log  2>&1 & 
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_mc  --channels mutau --decay-modes all,0,1,1011 --mc 1 >  ${tag}nohup-compare.log  2>&1 & 


# tag="2022preEE_2p1"
# Data="Data_2022-preEE.root"
# MC="MC_2022-preEE.root"

# python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}giventau_2 --conditional 1  --decay-modes all,0,1,1011   --channels mutau > ${tag}nohup-createTurnOn.log 
# python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}tau_2 --conditional 0  --decay-modes all,0,1,1011  --channels mutau > ${tag}nohup-createTurnOn.log 
# nohup python3 fitTurnOn.py --input Plot/${tag}giventau_2.root --output Plot/${tag}fitTurnOn --channels mutau --decay-modes all,0,1,1011  > ${tag}nohup-fitTurnOn.log 2>&1 &
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_data  --channels mutau --decay-modes all,0,1,1011 --mc 0 >  ${tag}nohup-compare.log  2>&1 & 
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_mc  --channels mutau --decay-modes all,0,1,1011 --mc 1 >  ${tag}nohup-compare.log  2>&1 & 

# tag="2022preEE_2p5"
# Data="Data_2022-preEE.root"
# MC="MC_2022-preEE.root"

# python3 createTurnOn.py --deeptau-ver "2p5" --input-data $Data --input-dy-mc $MC --output Plot/${tag}giventau_2 --conditional 1  --decay-modes all,0,1,1011   --channels mutau > ${tag}nohup-createTurnOn.log 
# python3 createTurnOn.py --deeptau-ver "2p5" --input-data $Data --input-dy-mc $MC --output Plot/${tag}tau_2 --conditional 0  --decay-modes all,0,1,1011  --channels mutau > ${tag}nohup-createTurnOn.log 
# nohup python3 fitTurnOn.py --input Plot/${tag}giventau_2.root --output Plot/${tag}fitTurnOn --channels mutau --decay-modes all,0,1,1011  > ${tag}nohup-fitTurnOn.log 2>&1 &
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_data  --channels mutau --decay-modes all,0,1,1011 --mc 0 >  ${tag}nohup-compare.log  2>&1 & 
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_mc  --channels mutau --decay-modes all,0,1,1011 --mc 1 >  ${tag}nohup-compare.log  2>&1 & 

# tag="2022postEE_2p1"
# Data="Data_2022-postEE.root"
# MC="MC_2022-postEE.root"

# python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}giventau_2 --conditional 1  --decay-modes all,0,1,1011   --channels mutau > ${tag}nohup-createTurnOn.log 
# python3 createTurnOn.py --deeptau-ver "2p1" --input-data $Data --input-dy-mc $MC --output Plot/${tag}tau_2 --conditional 0  --decay-modes all,0,1,1011  --channels mutau > ${tag}nohup-createTurnOn.log 
# nohup python3 fitTurnOn.py --input Plot/${tag}giventau_2.root --output Plot/${tag}fitTurnOn --channels mutau --decay-modes all,0,1,1011  > ${tag}nohup-fitTurnOn.log 2>&1 &
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_data  --channels mutau --decay-modes all,0,1,1011 --mc 0 >  ${tag}nohup-compare.log  2>&1 & 
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_mc  --channels mutau --decay-modes all,0,1,1011 --mc 1 >  ${tag}nohup-compare.log  2>&1 & 

# tag="2022postEE_2p5"
# Data="Data_2022-postEE.root"
# MC="MC_2022-postEE.root"

# python3 createTurnOn.py --deeptau-ver "2p5" --input-data $Data --input-dy-mc $MC --output Plot/${tag}giventau_2 --conditional 1  --decay-modes all,0,1,1011   --channels mutau > ${tag}nohup-createTurnOn.log 
# python3 createTurnOn.py --deeptau-ver "2p5" --input-data $Data --input-dy-mc $MC --output Plot/${tag}tau_2 --conditional 0  --decay-modes all,0,1,1011  --channels mutau > ${tag}nohup-createTurnOn.log 
# nohup python3 fitTurnOn.py --input Plot/${tag}giventau_2.root --output Plot/${tag}fitTurnOn --channels mutau --decay-modes all,0,1,1011  > ${tag}nohup-fitTurnOn.log 2>&1 &
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_data  --channels mutau --decay-modes all,0,1,1011 --mc 0 >  ${tag}nohup-compare.log  2>&1 & 
# nohup python3 compare.py  --input Plot/${tag}tau_2.root,Plot/${tag}giventau_2.root --output Plot/${tag}compare_mc  --channels mutau --decay-modes all,0,1,1011 --mc 1 >  ${tag}nohup-compare.log  2>&1 & 

