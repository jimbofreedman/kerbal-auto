import telnetlib
from time import sleep
import struct

conn = telnetlib.Telnet("localhost", 5410)
print(conn)
#conn.set_debuglevel(10)

naws_command = struct.pack('!BBBHHBB',
                           255, 250, 31, # IAC SB NAWS
                           200, 100,
                           255, 240) # IAC SE
conn.get_socket().send(naws_command)
conn.get_socket().send("vt100\n")

def get_mcu_number():
    t = conn.expect(["\[(\d+)\]\s*(yes|no)\s*\d*\s*jokemcu",])
    print(t)
    return t[1].group(1)

def readeager():
    t = conn.read_eager()
    print([ord(c) for c in t])

mcu_number = get_mcu_number()

t = conn.expect(["command line\.\)\s*[-\s]+\r\n> [\xee\x80\x01]*"])
print(t)

print("MCU is no " + str(mcu_number) + " - connecting...")
conn.write("1\n")


print("WRITE1")
t = conn.expect(["kOS","Garbled selection\. Try again\.\r\n"])
print(t)