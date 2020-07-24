#!/usr/bin/lua

todoList = {}

todoList[1] = "Arch Linux Installer Script in LUA\n\n"
todoList[2] = "\t[] Update System Clock"
todoList[3] = "\t[] Partition Drives"
todoList[4] = "\t[] Format Partitions"
todoList[5] = "\t[] Mount Paritions"
todoList[6] = "\t[] Pacman Mirrors"
todoList[7] = "\t[] Install Essential Packages"
todoList[8] = "\t[] Generate Fstab"
todoList[9] = "\t[] Chroot into new system"
todoList[10] = "\t[] Set Time Zone"
todoList[11] = "\t[] Localization"
todoList[12] = "\t[] Network Configuration"
todoList[13] = "\t[] Initramfs"
todoList[14] = "\t[] Root password"
todoList[15] = "\t[] Boot loader"


function printTodo()
    os.execute("clear")
    
    for i, line in pairs(todoList) do
        print(line)
    end
    print("\n")
end

function updateSystemClock()
    print("**Update System Clock**\n")
    os.execute("timedatectly set-ntp true")
    todoList[2] = "\t[*] Update System Clock"
    printTodo()
end


function partitionDrives()
    print("**Partition Drives**\n")
    os.execute("lsblk")
    print("\nPress Enter to begin disk partitioning")
    io.read()
    disksP = false

    while not disksP do
        os.execute("sudo cfdisk")
        os.execute("clear")
        os.execute("lsblk")
        print("\nType y if satisfied with partitions")
        local a = io.read()
        if a == "y" then
            disksP = true
        end
    end
    todoList[3] = "\t[*] Partition Drives"
    printTodo()
end


function formatPartitions()
    print("**Formation Paritions**\n")
    print("How many partitions need to be formatted? (DO NOT include swap)")
    drivesToP = io.read("*number")


    local i = 1

    while i <= (drivesToP+1) do
        os.execute("clear")
        os.execute("lsblk")
        print("\nDrive ", (i-1), ": ")
        print("\nType: mkfs.ext4 /dev/sdX#")
        print("\nRoot/Boot Example: mkfs.ext4 /dev/sda5")
        print("EFI Example: mkfs.fat -F32 /dev/sdb1")
        
        local cmd = io.read("*line")
        if cmd == nil then break end
        os.execute(cmd)
        i = i + 1
    end    

    os.execute("clear")
    printTodo()
    local didSwap = false
    
    while not didSwap do
        print("Did you designate a partition for swap? y/n")
        swapA = io.read()

        if swapA == "y" then
            os.execute("lsblk")
            print ("\nType:  mkswap /dev/sdX#")
            print("Then type: swapon /dev/sdX#")
            mkswap = io.read()
            swapon = io.read()
            
            os.execute(mkswap)
            os.execute(swapon)

            didSwap = true
            todoList[4] = "\t[*] Format Partitions"
        elseif swapA == "n" then
            didSwap = true
            todoList[4] = "\t[*] Format Partitions"
        end
    end
    printTodo()
end

function mountPartitions()
    os.execute("mkdir /mnt/efi")
    os.execute("mkdir /mnt/boot")
    os.execute("mkdir /mnt/home")
    print("**Mount Paritions**\n")
    local i = 2

    while i <= (drivesToP+1) do
        os.execute("lsblk")
        print("\nDrive ", (i-1), ": ")
        print("Type: mount /dev/sdX# /mnt")
        print("Example: mount /dev/sda1 /mnt/efi")
        print("Example: mount /dev/sda2 /mnt")
        print("Other mount points:  /mnt/efi   /mnt/home   /mnt/boot")
        local cmd = io.read("*line")
        if cmd == nil then break end
        os.execute(cmd)
        i = i + 1
    end
    todoList[5] = "\t[*] Mount Paritions"
    printTodo()
end


function pacmanMirrors()
    print("**Pacman Mirrors**")
    os.execute("reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist")

    todoList[6] = "\t[*] Pacman Mirrors"
    printTodo()
end



function installEssentialPackages()
    print("**Install Essential Packages**")
    os.execute("pacstrap /mnt base linux linux-firmware networkmanager")
        
    todoList[7] = "\t[*] Install Essential Packages"
    printTodo()
end



function generateFstab()
    print("**Generate Fstab**")
    os.execute("genfstab -U /mnt >> /mnt/etc/fstab")    
    
    todoList[8] = "\t[*] Generate Fstab"
    printTodo()
end



function chrootIntoNewSystem()
    print("**Chroot int new system**")
    os.execute("cp install /mnt/home/install")
    os.execute("arch-chroot /mnt lua /home/install chroot")
    todoList[9] = "\t[*] Chroot into new system"
    printTodo()
end

function setTimeZone()
    print("**Set Time Zone**")
    print("Do you want to see all available time zones? y/n")
    seeTimeZones = io.read()
    
    if seeTimeZones == "y" then
        os.execute("timedatectl list-timezones")
    end

    print("Type REGION/SUBZONE\n")
    print("*Examples for USA*")
    print("America/New_York")
    print("America/Chicago")
    print("America/Denver")
    print("America/Los_Angeles")
    print("America/Anchorage")
    print("Pacific/Honolulu")

    regionSubZone = io.read()

    os.execute("ln -sf /usr/share/zoneinfo/"..regionSubZone.." /etc/localtime")
    os.execute("hwclock --systohc")

    todoList[10] = "\t[*] Set Time Zone"
    printTodo()
end


function setLocalization()
    print("**Set Localization**")
    os.execute("sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen")

    os.execute("locale-gen")

    os.execute("echo \"LANG=en_US.UTF-8\" > /etc/locale.conf")

    todoList[11] = "\t[*] Localization"
    printTodo()
end


function networkConfiguration()
    print("**Network Configuration**")
    print("Type a hostname:")
    hostname = io.read()
    
    os.execute("echo "..hostname.." > /etc/hostname")
    
    os.execute("echo \"127.0.0.1 localhost\" > /etc/hosts")
    os.execute("echo \"::1 localhost\" >> /etc/hosts")
    os.execute("echo \"127.0.1.1 "..hostname..".localdomain "..hostname.."\" >> /etc/hosts")
    os.execute("systemctl enable NetworkManager")

    todoList[12] = "\t[*] Network Configuration"
    printTodo()
end

function setInitramfs()
    print("**Initramfs**")
    os.execute("mkinitcpio -P")

    todoList[13] = "\t[*] Initramfs"
    printTodo()
end

function setRootPassword()
    print("**Set Root Password**")
    os.execute("passwd")

    todoList[14] = "\t[*] Root password"
    printTodo()
end

function installBootLoader()
    print("**Install Boot Loader**")
    blInstalled = false

    while not blInstalled do
        print("UEFI or BIOS boot? (UEFI/BIOS)")
        bootStyle = io.read()

        if bootStyle == "UEFI" then
            os.execute("pacman -S grub --noconfirm")
            os.execute("pacman -S efibootmgr --noconfirm")
            print("Type mount point of efi partition (ex: /efi")
            esp = io.read()            
            os.execute("grub-install --target=x86_64-efi --efi-directory="..esp.." --bootloader-id=GRUB")
            os.execute("grub-mkconfig -o /boot/grub/grub.cfg")

            todoList[15] = "\t[*] Boot loader"
            printTodo()

        elseif bootStyle == "BIOS" then
            os.execute("pacman -S grub --noconfirm")
            os.execute("lsblk")
            print("\nWhich device to install bootloader?")
            print("Just type sda for example")
            blDevice = io.read()
            os.execute("grub-install --target=i386-pc /dev/"..blDevice)
            os.execute("grub-mkconfig -o /boot/grub/grub.cfg")

            todoList[15] = "\t[*] Boot loader"
            printTodo()
        end
    end
end


if arg[1] == "chroot" then
    setTimeZone()
    setLocalization()
    networkConfiguration()
    setInitramfs()
    setRootPassword()
    installBootLoader()
else
    updateSystemClock()
    partitionDrives()
    formatPartitions()
    mountPartitions()
    pacmanMirrors()
    installEssentialPackages()
    generateFstab()
    --chrootIntoNewSystem()
end