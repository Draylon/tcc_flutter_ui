import 'dart:math';

class BlurHashProvider{

  static final List<String> _lib = [r'LfNm_{?wIoRjx_R+M{WV^+E0V@j]',r'LsHw[FS4R+fk~9WWWWfjaeoKj?ay',r'LLHeUfPEO@o$Y8ofn2n#TKMwd;kD',r'LXI;0lEi9ZV[%jaeV@so0~wbj[kB',r'LeH{HBjbj]j@PXofa#WV}+a}Rkf5',r'LuG+U0t6WCay0$R*oLj@$foefRaf',r'LiP%FgenNHt7?wWCofWXw[ofoJjY',r'LDOzod~U%MN2SB-.t5IVt7WVxZM|',r'LnIrW%~CENocogn$jZfkX8WqWVay',r'LHHywDE-z:IoJ[%NF1j=0MOXO[xZ',r'LsMtQ]x]azof0?j]j[a}Diayfij]',r'LhIhyxFfNejF4T-9V@kC9uoyoyRk',r'LZJHs=^NI]s-0MxWofR+M|I;s.j=',r'LkI.~Mj[I=jt}=a}WCazE%j[s.az',r'LGHo:^%hyEyE1k-6s;xv8{9aR+NH',r'LzIiFIS%V?bb0lt6jYkCr?aJkWjY',r'LgHfhp=c0#x]jbaeWBayWBaej[oL',r'LhM81yxtRPof19s:azfQ^*jYWVjs',r'LTHoqND$4.xZ%%RPM{jYMwjsa}WB',r'LrNdH^xu%Mt7~qs:jujt?aIURjRj',r'LWKL:mq?MvjD5[9ZRORP%h%gt5aJ',r'LYLX_DEjD%WrPXxZWCoKaJn$o#W;',r'L~JbNy%1oeoL_Nofazfkn,WBayjt',r'LiP6y=WBWCj@*0WVjsj[W=a}j@a|',r'LmGIs1R.axj[~WR-fPfR%goKjsa|',r'LpJur?V@NHxacbj[WXWW4=oeogR*',r'LcED6oo#V@WW0jf,oJazwGWBaejZ',r'LvKKZj~BM{f657n%%2WVNGM|n%xa',r'L-JuQ6skoeoe0MadfPj?Vraya}a}',r'LlIp-{n$0dS4?HWUM{jZ9@bHxHWB',    r'LyKBwRRkoJof0pRjR*f6$*oeWBf5','LLD1f}xJ8^V=2]%h-VNFrZNtSwtR','L+MQkxt5E1WB_Nogt7s:R.WBS2ay','LhM81yxtRPof19s:azfQ^*jYWVjs','LjNAYVxGIoNG_4s:R*WBR+ofoLbH',r'LMQuEN~7sk%|^-J7oLXlK6r?n$x[','L~JbNy%1oeoL_Nofazfkn,WBayjt','LsHw[FS4R+fk~9WWWWfjaeoKj?ay','LgEW%sxvIUjc0sRjxuaeiIoebIj?','LnJiY39uSgRk}[M|X8f69|oJofoL','L.Mjjx9uRjWV_NWER*f7NHofofay','L|J*h:xtadRk_4oeRka}SiWBWCof','LcED6oo#V@WW0jf,oJazwGWBaejZ','LrNdH^xu%Mt7~qs:jujt?aIURjRj',r'LcK{SOs+bcWY0.R*slf6$yNIads.','LNNB7K-;tSnN1Pslo#V@W?kCWBWC','LRK_I4xbVsRQT}NGRjt7u5b^Rjt7','LQGktR5Z0h=t_4WZNHf*DjtQkXs-','LrOWyyofozj[~qj[V@j[j[ayayay',r'LYIE01}k$zxY^*w[WUW.RPaejFoL','LbK.3Uayofj[1iafjsfQx]j@ayfk',r'LgEX6CI?M|s.*0aeofWqNIbIs9n$','LkF?X]0KkCxu%hNFoJjtxuM{s:ax','LJHoqJ00aLxa.mR4MwM{4.x]RjIU','LGHo:^%hyEyE1k-6s;xv8{9aR+NH','LNKn;}ofL4aJV*s8wOW:^jt6r;jY',r'LYJ@g+9v4:xt_NRkRiof0$s.xtR*',r'LnIrW%~CENocogn$jZfkX8WqWVay','LRFs44-=McRN0*j]VrjD#5oft7t6','LvKKZj~BM{f657n%%2WVNGM|n%xa','LgEW%sxvIUjc0sRjxuaeiIoebIj?',r'LcFDl,EfEf$*}ZJANbs,$*R*jGba',r'LqNcZgM|s.ay~payWBa|0$kBRkfk','LzIiFIS%V?bb0lt6jYkCr?aJkWjY',r'LLJ]M$S%F~#j7ja}bcRj9iofr;b_',r'LTHoqND$4.xZ%%RPM{jYMwjsa}WB','L+MQkxt5E1WB_Nogt7s:R.WBS2ay',r'LAEA$V671g}r=|X8xGs:7M$%-AE%','LGFjEH5sDini1Bias:R*QkITtRoe','LRFs44-=McRN0*j]VrjD#5oft7t6',r'LdHNHXEVMd%M=kIrX8t5OqIBo$V@','LdNTRc?]j]X9k?aeWBWWE1j[a{WV',r'LMQuEN~7sk%|^-J7oLXlK6r?n$x[',r'LmL5H|EN4:$*Emoft7WB0Ln%n+jZ',r'LYJ@g+9v4:xt_NRkRiof0$s.xtR*','LcKoQAoIRRbIA1ofRkWV~CaxR*j[','LPEzvRkXRkkC7jofxaWC-9f6WBoe',r'LYIE01}k$zxY^*w[WUW.RPaejFoL','LZK_UZaJR*j[1iNdoLayemofofj@','LKMaePT}Rkt6pyR*w[aeR-wHM{x]',r'LVJk[q.9xbs:yZxZt7a#$%WAWVof','LjM*gUSjx[of7QIpn#j[,oNIoKbH','LBFFKl-;59Ot?d^iJWI@s;WVt8Ip','LhIhyxFfNejF4T-9V@kC9uoyoyRk','LYHfG5-;xuxa.AIVM{WBtQRjafR*',r'LyKBwRRkoJof0pRjR*f6$*oeWBf5','LQGktR5Z0h=t_4WZNHf*DjtQkXs-','LmGIs1R.axj[~WR-fPfR%goKjsa|','LmKx^|xawbWC?wIpWBof9~xabbWC','L|J*h:xtadRk_4oeRka}SiWBWCof',r'LlIp-{n$0dS4?HWUM{jZ9@bHxHWB', 'L~JbNy%1oeoL_Nofazfkn,WBayjt',r'LuG+U0t6WCay0$R*oLj@$foefRaf','LOHB@|IpoLNGpfsmaya}Nxt6R*t7','LlJHgVW?IpkC~oWqWBbHNHkCs,ay','LdG+?yk[g5f+T#j^adoJ?aRORiof','LNKn;}ofL4aJV*s8wOW:^jt6r;jY','LgK_LK8^M{yD%MM_s:t7V?ofofoK','LVJ*YP?vIUj[L4ofs8bI0Li^X9jZ','LvKKZj~BM{f657n%%2WVNGM|n%xa','LbHC_wVsM{j@YkV@ayjscEbIayfQ',r'LqF%P$WCRioe0Payodj[-Sj?bHj[',r'LYIE01}k$zxY^*w[WUW.RPaejFoL','LmGIs1R.axj[~WR-fPfR%goKjsa|','LrENn@yGMys*DlR:xuV=nhjFWDa|','LiP6y=WBWCj@*0WVjsj[W=a}j@a|','LFAwSdaeIURj0KWB%2V@,mj]bws:',r'LVJk[q.9xbs:yZxZt7a#$%WAWVof',r'L#Ju}$ofRitS0$bHo1o#$%bIjray','LDOzod~U%MN2SB-.t5IVt7WVxZM|', 'LZK_UZaJR*j[1iNdoLayemofofj@','LhIhyxFfNejF4T-9V@kC9uoyoyRk','LRK_I4xbVsRQT}NGRjt7u5b^Rjt7','LiP%FgenNHt7?wWCofWXw[ofoJjY',r'LyJ$tY=wn~aypMX7jray5XNLoLaz',r'LNDT9E-:S$R*3VNbs-od4nM{WVX8','LcNUO~yGxuM_%NIUogt8%OV@M{az','LMKBw4K*WAH?1KRPNGxux]wJayX9', r'LgEX6CI?M|s.*0aeofWqNIbIs9n$','LeH{HBjbj]j@PXofa#WV}+a}Rkf5'];
  late List<String> _copy;

  BlurHashProvider(){
    _copy=_lib.toList();
    _copy.shuffle();
  }
  String pick(){
    _copy.shuffle();
    return _copy.removeLast();
  }

  static String randPick(){
    return _lib[Random().nextInt(_lib.length-1)];
  }

/*_old_segment(){
    ApiRequests.get("/api/v1/util/blurhashes",{
      "tags_en":tags_en.toString(),
      "sensor_data":sensor_data.length.toString(),
      "within_city":within_city.length.toString(),
      "nearby_cities":nearby_cities.length.toString()
    }).then((syn_resp) => {
      _blur_hash_listing = json.decode(syn_resp.body),
    },onError: (e){
      print("failed to retrieve blurhash");
    });
  }*/

}