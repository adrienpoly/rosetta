require "test_helper"

class Rosetta::LocaleTest < ActiveSupport::TestCase
  test "valid locale" do
    assert Rosetta::Locale.new(name: "English", code: "en").valid?
  end

  test "default unpublished" do
    assert_not Rosetta::Locale.new(name: "English", code: "en").published
  end

  test "invalid without a name" do
    locale = Rosetta::Locale.new(name: nil, code: "en")
    locale.valid?
    assert_not locale.errors[:name].empty?
  end

  test "invalid without a code" do
    locale = Rosetta::Locale.new(name: "English", code: nil)
    locale.valid?
    assert_not locale.errors[:code].empty?
  end

  test "invalid with a duplicate code" do
    Rosetta::Locale.create(name: "English", code: "en")
    locale = Rosetta::Locale.new(name: "English", code: "en")
    locale.valid?
    assert_not locale.errors[:code].empty?
  end

  test "code format" do
    assert     Rosetta::Locale.new(name: "English", code: "en").valid?
    assert     Rosetta::Locale.new(name: "English", code: "EN").valid?
    assert     Rosetta::Locale.new(name: "English", code: "en-GB").valid?
    assert     Rosetta::Locale.new(name: "English", code: "EN-gb").valid?
    assert_not Rosetta::Locale.new(name: "English", code: "en-GB-UK").valid?
    assert_not Rosetta::Locale.new(name: "English", code: "qw12").valid?
  end

  test "available locales" do
    assert_equal 3, Rosetta::Locale.available_locales.length
    assert_equal [ :en, :fr, :es ], Rosetta::Locale.available_locales.pluck(:code).map(&:to_sym)
  end

  test "default locale" do
    default_locale = Rosetta::Locale.default_locale
    assert_equal "English", default_locale.name
    assert_equal "en", default_locale.code
    assert default_locale.default_locale?
    assert default_locale.readonly?
  end
end
