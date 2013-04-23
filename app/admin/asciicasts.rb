ActiveAdmin.register Asciicast do
  form do |f|
	f.inputs "Details" do
		f.input :title
		f.input :description
        end
	f.actions
  end
end
