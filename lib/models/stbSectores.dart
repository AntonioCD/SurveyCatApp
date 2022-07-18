class StbSector {
  int stbSectoresID = 0;
  String? cod_sector = '';
  String num_sector = '';
  String? sectorXdep = '';
  String? sectorXmun = '';

  StbSector(
      {required this.stbSectoresID,
      //required this.cod_sector,
      required this.num_sector
      //required this.sectorXdep,
      //required this.sectorXmun
      });

  StbSector.fromJson(Map<String, dynamic> json) {
    stbSectoresID = json['stbSectoresID'];
    //cod_sector = json['cod_sector'];
    num_sector = json['num_sector'];
    //sectorXdep = json['sectorXdep'];
    //sectorXmun = json['sectorXmun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stbSectoresID'] = this.stbSectoresID;
    //data['cod_sector'] = this.cod_sector;
    data['num_sector'] = this.num_sector;
    //data['sectorXdep'] = this.sectorXdep;
    //data['sectorXmun'] = this.sectorXmun;
    return data;
  }
}
