ActiveAdmin.register Vendor do
  menu    :parent => "Product Maintenance", :priority => 2  
  
  scope :all, :default => true
  scope :Aa do |vendors|
     vendors.where('name like ? or name like ?', 'A%', 'a%')
  end     
  scope :Bb do |vendors|
     vendors.where('name like ? or name like ?', 'B%', 'b%')
  end     
  scope :Cc do |vendors|
     vendors.where('name like ? or name like ?', 'C%', 'c%')
  end     
  scope :Dd do |vendors|
     vendors.where('name like ? or name like ?', 'D%', 'd%')
  end     
  scope :Ee do |vendors|
     vendors.where('name like ? or name like ?', 'E%', 'e%')
  end     
  scope :Ff do |vendors|
     vendors.where('name like ? or name like ?', 'F%', 'f%')
  end     
  scope :Gg do |vendors|
     vendors.where('name like ? or name like ?', 'G%', 'g%')
  end     
  scope :Hh do |vendors|
     vendors.where('name like ? or name like ?', 'H%', 'h%')
  end     
  scope :Ii do |vendors|
     vendors.where('name like ? or name like ?', 'I%', 'i%')
  end     
  scope :Jj do |vendors|
     vendors.where('name like ? or name like ?', 'J%', 'j%')
  end     
  scope :Kk do |vendors|
     vendors.where('name like ? or name like ?', 'K%', 'k%')
  end     
  scope :Ll do |vendors|
     vendors.where('name like ? or name like ?', 'L%', 'l%')
  end     
  scope :Mm do |vendors|
     vendors.where('name like ? or name like ?', 'M%', 'm%')
  end     
  scope :Nn do |vendors|
     vendors.where('name like ? or name like ?', 'N%', 'n%')
  end     
  scope :Oo do |vendors|
     vendors.where('name like ? or name like ?', 'O%', 'o%')
  end     
  scope :Pp do |vendors|
     vendors.where('name like ? or name like ?', 'P%', 'p%')
  end     
  scope :Qq do |vendors|
     vendors.where('name like ? or name like ?', 'Q%', 'q%')
  end     
  scope :Rr do |vendors|
     vendors.where('name like ? or name like ?', 'R%', 'r%')
  end     
  scope :Ss do |vendors|
     vendors.where('name like ? or name like ?', 'S%', 's%')
  end     
  scope :Tt do |vendors|
     vendors.where('name like ? or name like ?', 'T%', 't%')
  end     
  scope :Uu do |vendors|
     vendors.where('name like ? or name like ?', 'U%', 'u%')
  end     
  scope :Vv do |vendors|
     vendors.where('name like ? or name like ?', 'V%', 'v%')
  end     
  scope :Ww do |vendors|
     vendors.where('name like ? or name like ?', 'W%', 'w%')
  end     
  scope :Xx do |vendors|
     vendors.where('name like ? or name like ?', 'X%', 'x%')
  end     
  scope :Yy do |vendors|
     vendors.where('name like ? or name like ?', 'Y%', 'y%')
  end     
  scope :Zz do |vendors|
     vendors.where('name like ? or name like ?', 'Z%', 'z%')
  end     

  
  
  form :html => { :multipart => true } do |f|
      f.inputs "Vendor" do
        f.input :name
        f.input :url
        f.input :logo, :as => :file
      end
      f.buttons
  end  
  
end
