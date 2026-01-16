# Temporary import blocks to bring existing Route53 DKIM records into state
# These can be removed after successful deployment to all environments

import {
  to = aws_route53_record.ndr_ses_dkim_record[0]
  id = var.zone_id "_354zu3wfelxizjuiwe7vlko32axlahhk._domainkey.test.national-document-repository.nhs.uk._CNAME"
}

import {
  to = aws_route53_record.ndr_ses_dkim_record[1]
  id = var.zone_id "_gebrcz37rf52u4nmoajk3batpw2ulftm._domainkey.test.national-document-repository.nhs.uk._CNAME"
}

import {
  to = aws_route53_record.ndr_ses_dkim_record[2]
  id = var.zone_id "_bajwkwrnqbinvoqhysvqpqvzor2vwri7._domainkey.test.national-document-repository.nhs.uk._CNAME"
}
