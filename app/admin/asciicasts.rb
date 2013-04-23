ActiveAdmin.register Asciicast do
  form do |f|
	f.inputs "Details" do
		f.input :title
		f.input :description
		f.input :username
        end
	f.actions
  end
end
