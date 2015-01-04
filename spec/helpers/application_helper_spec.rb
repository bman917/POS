require "rails_helper"

describe ApplicationHelper do
  describe "modal_button" do

    shared_examples_for "a modal button" do
      it "should have a button css" do
        expect(link.to_s).to include("button")
      end
      it "should have reveal data attributes" do
        expect(link.to_s).to include("data-reveal-ajax=\"true\"")
        expect(link.to_s).to include("data-reveal-id=\"modal_form\"")
      end
    end

    describe "link with no css" do
      it_should_behave_like "a modal button" do
         let(:link) { modal_button('Test', '#') } 
      end
    end

    describe "link with css" do
      it_should_behave_like "a modal button" do
         let(:link) { modal_button('Test', '#', class: 'some_class') } 
      end
    end

    it "appends button css" do
       link = modal_button('Test', '#', class: 'some_class')
       expect(link.to_s).to include("button")
       expect(link.to_s).to include("some_class")
     end

    it "does not reappend button css" do
      link = modal_button('Test', '#', class: 'some_class button')
      expect(link.to_s).to include("class=\"some_class button\"")
    end
  end
end