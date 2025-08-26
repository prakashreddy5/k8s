
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --key=/home/cloud_user/etcd-certs/etcd-server.key \
  snapshot save /home/cloud_user/etcd_backup.db



# Stop etcd
sudo systemctl stop etcd

# Delete the existing etcd data
sudo rm -rf /var/lib/etcd

# Restore etcd data from a backup
sudo ETCDCTL_API=3 etcdctl snapshot restore /home/cloud_user/etcd_backup.db \
  --initial-cluster etcd-restore=https://etcd1:2380 \
  --initial-advertise-peer-urls https://etcd1:2380 \
  --name etcd-restore \
  --data-dir /var/lib/etcd

# Set database ownership
sudo chown -R etcd:etcd /var/lib/etcd

# Start etcd
sudo systemctl start etcd

chmod +x etcd_backup_restore.sh

./etcd_backup_restore.sh

# Verify the system is working
ETCDCTL_API=3 etcdctl get cluster.name \
  --endpoints=https://etcd1:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key