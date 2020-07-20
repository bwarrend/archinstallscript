#!/usr/bin/lua

todoList = {}

todoList[1] = "Arch Linux Installer Script in LUA\n\n"
todoList[2] = "[TODO] Update System Clock\n"
todoList[3] = "[TODO] Partition Drives\n"
todoList[4] = "[TODO] Mount Partitions\n"
todoList[5] = "[TODO] Format Partitions\n"
todoList[6] = "[TODO] "



os.execute("timedatectly set-ntp true")
os.execute("clear")
print("Updated the System Clock\n")
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

    
os.execute("clear")
print("Disks partitioned")

