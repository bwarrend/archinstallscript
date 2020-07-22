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
--EXIT CHROOT
todoList[15] = "\t[] Boot loader"


function printTodo()
    os.execute("clear")
    
    for i, line in pairs(todoList) do
        print(line)
    end
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
            print("Type: mkfs.ext4 /dev/sdX#")
            print("Example: mkfs.ext4 /dev/sda5")
            local cmd = io.read("*line")
            if cmd == nil then break end
            os.execute(cmd)
            i = i + 1
        end


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
    print("**Mount Paritions**\n")
    local i = 2

    while i <= (drivesToP+1) do
        os.execute("lsblk")
        print("\nDrive ", (i-1), ": ")
        print("Type: mount /dev/sdX# /mnt")
        print("/mnt for root")
        print("/mnt/efi   /mnt/home   /mnt/boot")
        local cmd = io.read("*line")
        if cmd == nil then break end
        os.execute(cmd)
        i = i + 1
    end
    todoList[5] = "\t[] Mount Paritions"
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
    print"**Chroot int new system**")
    os.execute("arch-chroot /mnt")
    todoList[9] = "\t[*] Chroot into new system"
    printTodo()
end


function setTimeZone()
    print("**Set Time Zone**")
    print("Do you want to see all available time zones? y/n")
    seeTimeZones = io.read()
    
    if seeTimeZones == "y"
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
    


    todoList[11] = "\t[*] Localization"
    printTodo()
end





updateSystemClock()
partitionDrives()
formatPartitions()
mountPartitions()
pacmanMirrors()
installEssentialPackages()
generateFstab()
chrootIntoNewSystem()
setTimeZone()

