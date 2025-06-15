require "application_system_test_case"

class OffersTest < ApplicationSystemTestCase
  setup do
    @offer = offers(:one)
  end

  test "visiting the index" do
    visit offers_url
    assert_selector "h1", text: "Offers"
  end

  test "should create offer" do
    visit offers_url
    click_on "New offer"

    fill_in "Accepted at", with: @offer.accepted_at
    fill_in "Item", with: @offer.item_id
    fill_in "Offered by", with: @offer.offered_by_id
    fill_in "Offered item text", with: @offer.offered_item_text
    fill_in "Status", with: @offer.status
    click_on "Create Offer"

    assert_text "Offer was successfully created"
    click_on "Back"
  end

  test "should update Offer" do
    visit offer_url(@offer)
    click_on "Edit this offer", match: :first

    fill_in "Accepted at", with: @offer.accepted_at.to_s
    fill_in "Item", with: @offer.item_id
    fill_in "Offered by", with: @offer.offered_by_id
    fill_in "Offered item text", with: @offer.offered_item_text
    fill_in "Status", with: @offer.status
    click_on "Update Offer"

    assert_text "Offer was successfully updated"
    click_on "Back"
  end

  test "should destroy Offer" do
    visit offer_url(@offer)
    accept_confirm { click_on "Destroy this offer", match: :first }

    assert_text "Offer was successfully destroyed"
  end
end
