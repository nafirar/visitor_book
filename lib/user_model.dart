class UserModel {
  String? id;
  String? nama;
  String? divisi;
  String? golongan;
  String? jabatan;
  String? nip;
  String? url;

  UserModel(
      {this.id = '',
      this.nama,
      this.divisi,
      this.golongan,
      this.jabatan,
      this.nip,
      this.url});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'divisi': divisi,
        'golongan': golongan,
        'jabatan': jabatan,
        'nip': nip,
        'url': url
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      nama: json['nama'],
      divisi: json['divisi'],
      golongan: json['golongan'],
      jabatan: json['jabatan'],
      nip: json['nip'],
      url: json['url']);
}
