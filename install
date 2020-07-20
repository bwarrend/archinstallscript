#!/usr/bin/lua

todoList = {}

todoList[1] = "Arch Linux Installer Script in LUA\n\n"
todoList[2] = "\t[TODO] Update System Clock"
todoList[3] = "\t[TODO] Partition Drives"
todoList[4] = "\t[TODO] Format Partitions"
todoList[5] = "\t[TODO] Mount Paritions"
todoList[6] = "\t[TODO] Pacman Mirrors"
todoList[7] = "\t[TODO] Install Essential Packages"
todoList[8] = "\t[TODO] Generate Fstab"
todoList[9] = "\t[TODO] Chroot in new system"
todoList[10] = "\t[TODO] Set Time Zone"
todoList[11] = "\t[TODO] Localization"
todoList[12] = "\t[TODO] Network Configuration"
todoList[13] = "\t[TODO] Initramfs"
todoList[14] = "\t[TODO] Root password"
--EXIT CHROOT
todoList[15] = "\t[TODO] Boot loader"


function printTodo()
    os.execute("clear")
    
    for i, line in pairs(todoList) do
        print(line)
    end
end

function updateSystemClock()
    print("**Update System Clock**\n")
    os.execute("timedatectly set-ntp true")
    todoList[2] = "[DONE] Update System Clock"
    printTodo()
end


function partitionDrives()
    print("**Partition Drives**\n")
    os.execute("lsblk")
    print("\nPress Enter to begin disk partitioning")
    io.read()
    disksP = false
    local i = 1
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
    printTodo()
end


function formatPartitions()
    print("**Formation Paritions**\n")
    print("How many partitions need to be formatted? (DO NOT include swap)")
    drivesToP = io.read("*number")
    drivesToP = drivesToP + 1
    

    for i = 1, drivesToP, 1 do
        print("\nDrive ", i, ": ")
        print("Type: mkfs.ext4 /dev/sdX#")
        print("Example: mkfs.ext4 /dev/sda5")
        cmd = io.read()
        os.execute(cmd)

        
    end
end




updateSystemClock()
partitionDrives()



--Mirrors
--reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
