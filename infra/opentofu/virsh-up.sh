for vm in k3s-master k3s-worker1; do
    virsh start $vm
done

virsh list --all

