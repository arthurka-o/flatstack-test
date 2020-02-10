RSpec::Matchers.define :be_a_project_representation do |project|
  match do |json|
    attributes = %i[id title]
    response_attributes = project.attributes.slice(*attributes)

    expect(json).to be
    expect(json).to include(response_attributes)
  end
end
