let
  firepitAccess = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoaiYQuYPYO217IA8rGIVvbQCoVaqERGAGevq+WxutrcdUZraa2Zp44GEZEmNFVNlgm2FtkOV42vqwnx2gfkHmuYA38Cov9jbxtIv4ytaWve+UniNBtUF9De0ULqKTUErk5iBX7gBpg4hY2+GVSSrYJ4KZIwDbA6uNj7PTyQDSZrGfQMbFR52HEXttehg7/vMXUVwhnakpKk3v21bCQRNzc3K9dcFUDSTH1uOE1oEfKhGp2zHtnknLDlMIhGQcpwfOKPqURsbzXpln1EyEMlrudjMRDg/ZKsKxYuW0Lnbxqqifgm9ERvSeq+517j3QA2Z6EWLY5yejgcDiyDy8bvqV";
in {
  "firepitAccess.age".publicKeys = [ firepitAccess ];
  "firepitAccess.age".owner = "aether";
}
