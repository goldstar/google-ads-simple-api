module GoogleAdsSimpleApi
  module Reports
    class CampaignPerformanceReport < Base

      report_definition(
        :selector => {
          :fields => [
            'CampaignId','CampaignName','CampaignStatus','CampaignGroupId',
            'TrackingUrlTemplate', 'UrlCustomParameters','StartDate',
            'Impressions', 'Clicks', 'Conversions', 'ConversionValue',
            'AveragePosition', 'Cost', 'Labels'],
          :predicates => [
            {
              :field => 'CampaignStatus',
              :operator => 'IN',
              :values => ['ENABLED','PAUSED']
            }
          ]
        },
        :report_name => 'Last 7 days CAMPAIGN_PERFORMANCE_REPORT',
        :report_type => 'CAMPAIGN_PERFORMANCE_REPORT',
        :download_format => 'CSV',
        :date_range_type => 'LAST_7_DAYS'
    )

    json_columns(:labels, :custom_parameter)
    integer_columns(:impressions, :clicks, :conversions, :campaign_id, :campaign_group_id)
    float_columns(:avg_position)
    currency_columns(:cost, :total_conv_value)
    date_columns(:start_date)
    end
  end
end
