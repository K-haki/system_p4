/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/
const bit<16> TYPE_MYTUNNEL = 0x1212;
const bit<16> TYPE_IPV4 = 0x800;
const bit<32> MAX_TUNNEL_ID = 1 << 16;

const bit<8> IP_PROTOCOLS_TCP        =   6;
const bit<8> IP_PROTOCOLS_UDP        =  17;
const bit<19> BURST_THRESHOLD = 10;


typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;


header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

header tcp_t{
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;

}

header tcp_t1{
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
    bit<192> options;

}
header tcp_t2 {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
    bit<256> options;

}
header tcp_t3 {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
    bit<320> options;

}

header udp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> length_;
    bit<16> checksum;
}
//quick turn
struct micbudata_t{
        bit<48> secondtimer;
        bit<8> micbunumebr;
        bit<8> allnumebr;
        bit<48> starttime;
        bit<48> finishtime;

        bit<48> last_timestamp;

}
struct metadata {
    bit<32> ecmp_select;
    bit<32> flag;

    micbudata_t micbudata;

    bit<48> timer;
    bit<48> last_timestamp;
    bit<32> flow_index;
    bit<32> flow_reverse_index;
    bit<32> tempseq;
    bit<32> tempack;
    bit<16> yes;

    bit<32> totlen_port2;
    bit<32> flow_speed;
    bit<32> state;
    bit<32> temp_pro;

    bit<32> in_count;
    bit<32> out_count;

    bit<8> microburst_flag;
    bit<8> first_RL_flag;
    bit<19> last_enq_qdepth;
    bit<32> sum_packet;
    bit<48> microburst_start_time;
    bit<48> microburst_finish_time;
    bit<32> microburst_scale;

    bit<8> loss_rate;
    bit<8> average_loss_rate;
    bit<8> reward;
    bit<32> opa;
    bit<32> opb;
    bit<8> divide_flag;

    bit<32> temp_state;
    bit<32> temp_action;
    bit<8> init;

    bit<32> temp_state_value;
    bit<8> port2_pro;
    bit<8> port3_pro;
    bit<8> port3_pro_dev;
    bit<8> port4_pro;
    bit<8> port4_pro_dev;
    bit<32> port3_probability;
    bit<32> port4_probability;

    bit<32> port3_count;
    bit<32> port4_count;
    bit<32> SACK_count;
    bit<8> option_kind;

    bit<32> 	microburst_start;
    bit<32> microburst_finish;

    bit<32> previous_value;
    bit<32> after_value;

    bit<19> max_enq_qdepth;
}

struct headers {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    tcp_t      tcp;
    udp_t      udp;
    tcp_t1     tcp1;
    tcp_t2     tcp2;
    tcp_t3     tcp3;
}



register<bit<8>>(1) reg_init_flag;
register<bit<8>>(1024) reg_average_loss_rate;//store average_loss_rate of state s

//quick turn
register<bit<48>>(1) reg_timestamp;
register<bit<48>>(2) reg_sectimestamp;

register<bit<48>>(3) reg_microburst_timestamp;//start,finish


register<bit<32>>(4) reg_metric_totlen;
register<bit<8>>(2) reg_microburst_flag; //microburst flag / first RL flag
register<bit<19>>(2) reg_microburst_history;
register<bit<32>>(1024) reg_states; //all states
register<bit<32>>(2) reg_last_state_action; //previous state, previous action in last microburst
register<bit<32>>(3) reg_packet_count;//count ingress/egress packet to calculate packet loss  in_count/out_count/sum loss packet/
register<bit<32>>(1) reg_microburst_scale;//calcualte microburst scale = sum of (tot_len - port_speed) in microburst period
register<bit<32>>(8) reg_test;
register<bit<32>>(1) reg_SACK_count;
register<bit<32>>(2) reg_microburst_counter;
#define REPLY_THRESHOLD 5
#define SMALL_THRESHOLD 64
#define PORT_SPEED 104


/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {

        transition parse_ethernet;
    }
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            0x800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        packet.extract(hdr.ipv4);

        transition select(hdr.ipv4.protocol) {
            6: parse_tcp;
            17: parse_udp;
            default: accept;
        }
    }

    state parse_tcp {


    if(hdr.ipv4.totalLen == 0x0050){
    packet.extract(hdr.tcp3);
    }else if(hdr.ipv4.totalLen == 0x0040){
     packet.extract(hdr.tcp1);
    }else if(hdr.ipv4.totalLen == 0x0048){
     packet.extract(hdr.tcp2);
    }else{
    packet.extract(hdr.tcp);
    }
    transition accept;
    }
    state parse_udp {

	packet.extract(hdr.udp);
	transition accept;
    }
}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {}
}

/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    counter(MAX_TUNNEL_ID, CounterType.packets_and_bytes) ingressTunnelCounter;
    bit<32> temp_state;

    action drop() {
        mark_to_drop(standard_metadata);
    }
    action ipv4_select_forward(egressSpec_t port) {

          standard_metadata.egress_spec = port;
        //hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;

          hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
          ingressTunnelCounter.count((bit<32>) port);

    }


    action set_designate_nhop(bit<9> port1)    {
        //hdr.ethernet.dstAddr = nhop_dmac;

          standard_metadata.egress_spec = port1;
          hdr.ipv4.ttl = hdr.ipv4.ttl - 1;

          ingressTunnelCounter.count((bit<32>)port1 + 10);
          }

    table ecmp_group {
        key = {
            hdr.ipv4.dstAddr: lpm;
            //decide if action ipv4_select_forward has been executed
            meta.flag: exact;
        }
        actions = {
            drop;
           NoAction;
	    set_designate_nhop;
        }
        default_action=NoAction();
        size = 2048;
    }

    table select_forward_exact {
        key = {
	    hdr.ipv4.dstAddr: exact;
        }
        actions = {
            drop;
            ipv4_select_forward;
	    NoAction;
        }
	default_action=NoAction();
        size = 1024;
    }
    apply {


        //digest(1,meta.yes);
	//init the registers
        if (hdr.ipv4.isValid()) {

           /*

            reg_init_flag.read(meta.init,0);
            if(meta.init < 2){
            	reg_packet_count.write(0,0);
            	reg_packet_count.write(1,0);
            	reg_packet_count.write(2,0);
                reg_microburst_scale.write(0,0);
            	reg_init_flag.write(0,2);
            	reg_average_loss_rate.write(0,0);
                reg_microburst_flag.write(0,0);

      */


	    //decide if action ipv4_select_forward has been executed
	    meta.flag = 1;
            select_forward_exact.apply();
            ecmp_group.apply();



           //Count ingress packets
           reg_packet_count.read(meta.in_count, 0);
           meta.in_count = meta.in_count + 1;
           reg_packet_count.write(0, meta.in_count);

 	   //input of RL, totlen_port2 represent the total bytes transfered in port2 in 1us
           if(standard_metadata.egress_spec == (bit<9>)2 || standard_metadata.ingress_port == (bit<9>)2){
     	      reg_metric_totlen.read(meta.totlen_port2,0);
  	      meta.totlen_port2 = meta.totlen_port2 + (bit<32>)hdr.ipv4.totalLen;
     	      reg_metric_totlen.write(0,meta.totlen_port2);

           }
//quick turn

           //timer (calculate how much time has been spent since last packet
           reg_timestamp.read(meta.last_timestamp, (bit<32>)0);
      meta.timer = standard_metadata.ingress_global_timestamp - meta.last_timestamp;

	   //refresh register per microsecond
	   if(meta.timer > 100){

	   	//digest(1,meta.yes);
	   	//add up bytes to calculate microburst scale
		if(meta.totlen_port2 > PORT_SPEED){
			reg_microburst_scale.read(meta.microburst_scale,0);
			meta.microburst_scale = meta.microburst_scale + (meta.totlen_port2 - PORT_SPEED);
			reg_microburst_scale.write(0,meta.microburst_scale);
		}

			//update timestamp
      //quick turn

			reg_timestamp.write((bit<32>)0, standard_metadata.ingress_global_timestamp);
			//update register
			reg_metric_totlen.write(0,0);

	   }



			//microburst occurs.
			//microburst_flag represent a microburst occurs
			//first_RL_flag=0 represent the codes below would only execute once during microburst period.
			reg_microburst_flag.read(meta.microburst_flag,0);
			reg_microburst_flag.read(meta.first_RL_flag, 1);
			if(meta.microburst_flag == 1){



			//calculate state
			hash(meta.state, HashAlgorithm.crc32, 32w0, {meta.totlen_port2}, 32w1024);


			//add new state
			reg_states.read(temp_state,meta.state);
			if(temp_state == 0){
				//init  port2,port3,port4  pro_init = 127  pro_range=0~255
				reg_states.write(meta.state,0x007f7f7f);
				reg_states.read(temp_state,meta.state);
			}

			//pick action for egress packets
			/******NEED TO CHANGE PORT****/

			//use another meta data to represent
			meta.port3_probability = (temp_state & 0x0000ff00) >> 8;
			meta.port4_probability = temp_state & 0x000000ff;




			if((meta.port3_probability > meta.port4_probability) && (standard_metadata.ingress_port == 1 || standard_metadata.ingress_port == 5)){
				standard_metadata.egress_spec = 3;
				reg_test.read(meta.port3_count ,6);
				meta.port3_count = meta.port3_count + 1;
				reg_test.write(6, meta.port3_count);

			}else if((meta.port3_probability <= meta.port4_probability) && (standard_metadata.ingress_port == 1 || standard_metadata.ingress_port == 5)){
				standard_metadata.egress_spec = 4;
				reg_test.read(meta.port4_count ,7);
				meta.port4_count = meta.port4_count + 1;
				reg_test.write(7, meta.port4_count);
			}
      }



			/******NEED TO CHANGE PORT****/
			if(meta.first_RL_flag == 0 && (standard_metadata.egress_spec == 3 || standard_metadata.egress_spec == 4) && (standard_metadata.ingress_port == 1 || standard_metadata.ingress_port == 5) ){
			    //change first_RL_flag to 1
			    reg_microburst_flag.write(1,1);
			    //reg_test.write(6,666);
			    //record state and action for probability updates
			    reg_last_state_action.write(0, meta.state);
			    reg_last_state_action.write(1,(bit<32>)standard_metadata.egress_spec);
			}


			}


		//SACK 40bits
		if (hdr.tcp3.isValid()){
		meta.option_kind = hdr.tcp3.options[207:200];
		if(meta.option_kind == 0x05){
		    reg_SACK_count.read(meta.SACK_count, 0);
		    meta.SACK_count = meta.SACK_count + 1;
                   reg_SACK_count.write(0, meta.SACK_count);
                }


                }

                //SACK 32bits
                if (hdr.tcp2.isValid()){
		meta.option_kind = hdr.tcp2.options[143:136];
		if(meta.option_kind == 0x05){
		    reg_SACK_count.read(meta.SACK_count, 0);
		    meta.SACK_count = meta.SACK_count + 1;
                   reg_SACK_count.write(0, meta.SACK_count);
                }


                }

                //SACK 24bits
                if (hdr.tcp1.isValid()){
		meta.option_kind = hdr.tcp1.options[79:72];
		if(meta.option_kind == 0x05){
		    reg_SACK_count.read(meta.SACK_count, 0);
		    meta.SACK_count = meta.SACK_count + 1;
                   reg_SACK_count.write(0, meta.SACK_count);
                }


                }




    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    counter(MAX_TUNNEL_ID, CounterType.packets_and_bytes) egressTunnelCounter;
    action rewrite_mac(bit<48> smac) {
        hdr.ethernet.srcAddr = smac;
	 egressTunnelCounter.count((bit<32>)10);
    }
    action drop() {
        mark_to_drop(standard_metadata);
    }
    table send_frame {
        key = {
            standard_metadata.egress_port: exact;
        }
        actions = {
            rewrite_mac;
            NoAction;
            drop;
        }
        default_action=NoAction();
        size = 256;
    }
    apply {

     if (hdr.ipv4.isValid()) {

       //Count Egress packet
       reg_packet_count.read(meta.in_count, 0);
       reg_packet_count.read(meta.out_count, 1);
       meta.out_count = meta.out_count + 1;
       reg_packet_count.write(1,meta.out_count);




        //|-|means if the result < 0 , the operation will not be executed
        //record loss packets
       reg_packet_count.write(2,(meta.in_count |-| meta.out_count)); //loss packet
       reg_packet_count.write(2,(meta.out_count |-| meta.in_count)); //loss packet






        send_frame.apply();
        //record enq_qdepth
        reg_microburst_history.read(meta.last_enq_qdepth,0);
        reg_microburst_flag.read(meta.microburst_flag,0);
        //microburst start
        if(standard_metadata.enq_qdepth > BURST_THRESHOLD && (meta.microburst_flag == 0)){  /*************** > -> >=**/


            meta.micbudata.micbunumebr = meta.micbudata.micbunumebr+1;
            meta.micbudata.allnumebr = meta.micbudata.allnumebr+1;

		        reg_microburst_counter.read(meta.microburst_start, 0);
		        meta.microburst_start = meta.microburst_start + 1;
		        reg_microburst_counter.write(0,  meta.microburst_start);



//quick turn
      //egress_global_timestamp;via the paramers
      //register<bit<48>>(1) reg_sectimestamp;
      /*struct micbudata_t{
              bit<48> secondtimer;
              bit<8> micbunumebr;
              bit<8> allnumebr;
              bit<48> starttime;
              bit<48> finishtime;

              bit<48> last_timestamp

      }*/
  //timer (calculate how much time has been spent since last packet
reg_sectimestamp.read(meta.micbudata.secondtimer, (bit<32>)0);
meta.micbudata.secondtimer = standard_metadata.egress_global_timestamp - meta.micbudata.secondtimer;


 //refresh register per microsecond
 if(meta.micbudata.secondtimer  > 1000000){

  digest<micbudata_t>(1,meta.micbudata);

  meta.micbudata.micbunumebr=0;
  meta.micbudata.secondtimer = standard_metadata.egress_global_timestamp;
  reg_sectimestamp.write((bit<32>)0, meta.micbudata.secondtimer);

}
//quick turn



        //each second it record the number of microburst happen
          meta.microburst_flag = 1;
        	reg_microburst_flag.write(0, meta.microburst_flag);
        	reg_packet_count.write(1,0);
        	reg_packet_count.write(2,0);
        	reg_SACK_count.write(0, 0);
        	reg_packet_count.write(0,0);

        	reg_microburst_scale.write(0,0);
        		reg_test.write(1,0);
        	//record microburst start time
        	reg_microburst_timestamp.write(0, standard_metadata.ingress_global_timestamp);
        }//microburst finish
        else if(standard_metadata.enq_qdepth == 0 && meta.last_enq_qdepth > 0 && (meta.microburst_flag == 1)){    /*********88 >0 -> >=0***/

        	       reg_microburst_counter.read(meta.microburst_finish, 1);
		             meta.microburst_finish= meta.microburst_finish + 1;
		             reg_microburst_counter.write(1,  meta.microburst_finish);

        	reg_test.write(0,meta.state);
        	meta.microburst_flag = 0;
        	reg_microburst_flag.write(0, meta.microburst_flag);
        	//reset first_RL_flag
        	reg_microburst_flag.write(1,0);

        	//record microburst finish time
        	reg_microburst_timestamp.read(meta.microburst_start_time,0);
        	reg_microburst_timestamp.write(1, standard_metadata.ingress_global_timestamp);
        	reg_microburst_timestamp.write(2, standard_metadata.ingress_global_timestamp |-| meta.microburst_start_time);

        	//when microburst end, give reward
        	/********test*/

        	//reg_SACK_count.read(meta.opb, 0);


        	reg_packet_count.read(meta.opb,2);//opb = the sum of loss packet during microburst period
        	reg_microburst_scale.read(meta.opa,0);//opa = microburst scale

        	//change bytes to packet
        	meta.opa = meta.opa >> 8;


            	/*
                //calculate  opb/opa, we need opb<opa
            	  meta.divide_flag=0x80;
           	  meta.loss_rate=0x00;

  	        //8 rounds calculation
                if(meta.opa <= meta.opb && meta.opb!=0 ){
                  meta.opb=meta.opb-meta.opa;
                  meta.loss_rate = meta.loss_rate | meta.divide_flag;
                  }
                  meta.opa = meta.opa >> 1;
                  meta.divide_flag = meta.divide_flag >> 1;


                if(meta.opa<=meta.opb && (meta.opb!=0) ){
                  meta.opb=meta.opb-meta.opa;
                  meta.loss_rate = meta.loss_rate | meta.divide_flag;
                  }
                  meta.opa = meta.opa >> 1;
                  meta.divide_flag = meta.divide_flag >> 1;


                if(meta.opa<=meta.opb && meta.opb!=0 ){
                    meta.opb=meta.opb-meta.opa;
                    meta.loss_rate = meta.loss_rate | meta.divide_flag;
                    }
                    meta.opa= meta.opa>>1;
                    meta.divide_flag = meta.divide_flag>>1;


                if(meta.opa<=meta.opb && meta.opb!=0 ){
                    meta.opb=meta.opb-meta.opa;
                    meta.loss_rate = meta.loss_rate | meta.divide_flag;
                    }
                    meta.opa= meta.opa>>1;
                    meta.divide_flag = meta.divide_flag>>1;
                if(meta.opa<=meta.opb && meta.opb!=0 ){
                      meta.opb=meta.opb-meta.opa;
                      meta.loss_rate = meta.loss_rate | meta.divide_flag;
                }
                    meta.opa= meta.opa>>1;
                    meta.divide_flag = meta.divide_flag>>1;


                if(meta.opa <= meta.opb && meta.opb!=0 ){
                   meta.opb=meta.opb-meta.opa;
                   meta.loss_rate = meta.loss_rate | meta.divide_flag;
                      }
                   meta.opa= meta.opa>>1;
                   meta.divide_flag = meta.divide_flag>>1;

                if(meta.opa <= meta.opb && meta.opb!=0 ){
                     meta.opb=meta.opb-meta.opa;
                     meta.loss_rate = meta.loss_rate | meta.divide_flag;
                     }
                     meta.opa= meta.opa>>1;
                     meta.divide_flag = meta.divide_flag >> 1;


                if(meta.opa <= meta.opb && meta.opb!=0 ){
                     meta.opb=meta.opb-meta.opa;
                     meta.loss_rate = meta.loss_rate | meta.divide_flag;
                     }
                     meta.opa= meta.opa>>1;
                     meta.divide_flag = meta.divide_flag >> 1;
		*/
                      //meta.loss_rate is opb/opa
                     //get last state and action for probability updates


                     //***********************test****//
                     meta.loss_rate = (bit<8>)meta.opb;



 	             reg_last_state_action.read(meta.temp_state,0);
 	             reg_last_state_action.read(meta.temp_action,1);

 	             reg_test.write(2,(bit<32>)meta.loss_rate);
 	             reg_states.read(meta.previous_value, meta.temp_state);
 	             reg_test.write(4,meta.previous_value);


 	             //get history, average_loss_rate
 	             reg_average_loss_rate.read(meta.average_loss_rate, meta.temp_state);
 	             //reward = loss_rate - average_loss_rate in specific State !!! reward could be negative

 	             //how to calculate when loss_rate == 0?
 	             if(meta.loss_rate >= meta.average_loss_rate){
 	                 meta.reward = meta.loss_rate |-| meta.average_loss_rate;
 	             }else{
 	                 meta.reward = meta.average_loss_rate |-| meta.loss_rate;
 	             }

 	             reg_test.write(3,(bit<32>)meta.reward);


 	             //update probability
 	             //plus action 3 , reduce action 4
 	             if((meta.temp_action == 3 && (meta.loss_rate <= meta.average_loss_rate)) || (meta.temp_action == 4 && (meta.loss_rate >= meta.average_loss_rate))){
 	             	   reg_test.write(1,1);
 	                 reg_states.read(meta.temp_state_value, meta.temp_state);
 	                 meta.port2_pro = (bit<8>)((meta.temp_state_value & 0x00ff0000) >> 16);
 	                 meta.port3_pro = (bit<8>)((meta.temp_state_value & 0x0000ff00) >> 8);
 	                 meta.port4_pro = (bit<8>)(meta.temp_state_value & 0x000000ff);

 	                 //
 	                 meta.port3_pro_dev = 0xff - meta.port3_pro;
 	                 if(meta.port3_pro_dev >= meta.reward){
 	                     meta.port3_pro = meta.port3_pro + meta.reward;
 	                 }else{
 	                     meta.port3_pro = 0xff;
 	                 }


 	                 if(meta.port4_pro >= meta.reward){
 	                     meta.port4_pro = meta.port4_pro - meta.reward;
 	                 }else{
 	                     meta.port4_pro = 0;
 	                 }

 	             }else if((meta.temp_action == 4 && (meta.loss_rate <= meta.average_loss_rate)) || ((meta.temp_action == 3 && (meta.loss_rate >= meta.average_loss_rate)))){
 	                 reg_test.write(1,2);
 	                 reg_states.read(meta.temp_state_value, meta.temp_state);
 	                 meta.port2_pro = (bit<8>)((meta.temp_state_value & 0x00ff0000) >> 16);
 	                 meta.port3_pro = (bit<8>)((meta.temp_state_value & 0x0000ff00) >> 8);
 	                 meta.port4_pro = (bit<8>)(meta.temp_state_value & 0x000000ff);

 	                 //meta.port2_pro = meta.port2_pro
 	                 meta.port4_pro_dev = 0xff - meta.port4_pro;
 	                 if(meta.port4_pro_dev >= meta.reward){
 	                     meta.port4_pro = meta.port4_pro + meta.reward;
 	                 }else{
 	                     meta.port4_pro = 0xff;
 	                 }


 	                 if(meta.port3_pro >= meta.reward){
 	                     meta.port3_pro = meta.port3_pro - meta.reward;
 	                 }else{
 	                     meta.port3_pro = 0;
 	                 }
 	             }

 	             meta.temp_state_value = (((bit<32>)meta.port2_pro) << 16) + (((bit<32>)meta.port3_pro) << 8) + (bit<32>)(meta.port4_pro);
 	             reg_states.write(meta.temp_state, meta.temp_state_value);

 	             reg_states.read(meta.after_value, meta.temp_state);
 	             reg_test.write(5,meta.after_value);


 	             //update average_loss_rate
 	             if(meta.average_loss_rate == 0){
 	                 meta.average_loss_rate = meta.loss_rate;
 	             }else if(meta.loss_rate != 0){
 	                 meta.average_loss_rate = (meta.average_loss_rate + meta.loss_rate) >> 1;
 	             }


 	             reg_average_loss_rate.write(meta.temp_state, meta.average_loss_rate);






        }
        //record enq_qdepth to judge if microburst occurs

        reg_microburst_history.write(0, standard_metadata.enq_qdepth);

        reg_microburst_history.read(meta.max_enq_qdepth,1);
        if(standard_metadata.enq_qdepth > meta.max_enq_qdepth){
        reg_microburst_history.write(1, standard_metadata.enq_qdepth);
        }
        //default queue capacity is 64packets. we can use set_queue_depth and set_queue_rate to modify paras
        	//reg_enqueue.write(0,(bit<32>)standard_metadata.enq_qdepth);
		//reg_enqueue.write(1,(bit<32>)standard_metadata.deq_qdepth);

    }
    }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
        packet.emit(hdr.tcp1);
        packet.emit(hdr.tcp2);
        packet.emit(hdr.tcp3);

    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
