module AdwordsSimpleApi
  RSpec.shared_examples "it has base finders" do
    describe ".all" do
      context "with no predicates" do
        before do
          allow(described_class.service).to receive(:get).with({ fields: described_class.field_names }).and_return(
            entries: [ described_class_attributes ]
          )
        end

        let(:results){ described_class.all }

        it "should return an array of #{described_class.name}" do
          expect(results).to be_an(Array)
          expect(results.first).to be_a(described_class)
        end
      end

      context "with predicates" do
        before do
          allow(described_class.service).to receive(:get).with({
            fields: described_class.field_names,
            predicates: [{field: 'CampaignId', operator: 'IN', values: [99]}]
          }).and_return(
            entries: [ described_class_attributes ]
          )
        end

        let(:results){ described_class.all(campaign_id: 99) }

        it "should return an array of #{described_class.name}" do
          expect(results).to be_an(Array)
          expect(results.first).to be_a(described_class)
        end
      end

    end

    describe ".find_by" do
      before do
        allow(described_class.service).to receive(:get).with(
          hash_including(
            predicates: [{field: described_class.field_name(:name), operator: 'IN', values: [described_class_attributes[:name]]}]
          )
        ).and_return(entries: [described_class_attributes])
      end

      let(:subject) { described_class.find_by(name: described_class_attributes[:name]) }
      it "should return a #{described_class.name} object" do
        expect(subject).to be_a(described_class)
      end

      it "should have attributes" do
        expect(subject).to have_attributes(described_class_attributes)
      end
    end

    describe ".find" do
      it "should find by id" do
        expect(described_class).to receive(:find_by).with(id: 1).and_return(nil)
        described_class.find(1)
      end
    end
  end
end
