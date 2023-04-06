# APK REPOSITORY 

Uygulamalar derlenirken oluşan apk'ların, Lottfs01 sunucusunda bulunan overtech-apk-repository klasöründe tutulması ve paylaşılma ile ilgilidir.



## Gereksinimler

- Windows sunucu (Lottfs01)

- Paylaşım yapılmış ve izinleri verilmiş klasör (C:\overtech-apk-repository)

- Linux sunucusuna `cifs-utils` yüklenmeli (sudo apt install cifs-utils)
### Projeyi Paylaşmak

İlk olarak dosya özel ağdaki belirli kişiler ya da herkes ile paylaşılır.

```bash
  file://192.168.85.120/overtech-apk-repository/
```
### Mount Windows to Linux

```bash
  sudo mount -t cifs -o username=<win_share_user> //WIN_SHARE_IP/<share_name> /mnt/win_share
```

 - [Resource Link](https://linuxize.com/post/how-to-mount-cifs-windows-share-on-linux/) 


### Mount Windows to Mac

```bash
  mount_smbfs //user@SERVER/folder ./mntpoint
```
 - [Resource Link](https://apple.stackexchange.com/questions/697/how-can-i-mount-an-smb-share-from-the-command-line) 

## Ekler

Aynı isimli dosya mevcutsa yenisi ile değiştirilir. 
```bash
  echo 'y' | cp -i ../../$APK_FULL_NAME /Users/overtech/lottfs01_shared
```

```bash
  overpay_pos_3.12.9+115_2023-04-05_18-05-45_commit-id-e126ae2c_branch-master.apk
```