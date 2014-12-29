if [ -z "$1" ]; then
  echo "Maximus ALL=(ALL:ALL) ALL"
  export EDITOR=$0 && sudo -E visudo
else
  echo "Changing sudoers"
  echo "# Dummy change to sudoers" >> $1
fi
